lambda = 0.2:0.1:0.9;
mu = 1;
numEvents = 10000; 

avgQueueLength = zeros(length(lambda), 1);
avgResponseTime = zeros(length(lambda), 1);

for i = 1:length(lambda)
    arrivalTimes = cumsum(exprnd(1/lambda(i), numEvents, 1));
    serviceTimes = exprnd(1/mu, numEvents, 1);
    departureTimes = zeros(numEvents, 1);
    
    for j = 1:numEvents
        if j == 1
            departureTimes(j) = arrivalTimes(j) + serviceTimes(j);
        else
            departureTimes(j) = max(arrivalTimes(j), departureTimes(j-1)) + serviceTimes(j);
        end
    end
    
    responseTimes = departureTimes - arrivalTimes;
    avgResponseTime(i) = mean(responseTimes);
    avgQueueLength(i) = lambda(i) * avgResponseTime(i);
end

% Analytical model
rho = lambda / mu;
analyticalResponseTime = 1 ./ (mu - lambda);
analyticalQueueLength = rho .^ 2 ./ (1 - rho);

% Plot
figure;
subplot(2, 1, 1);
plot(lambda, avgResponseTime, 'o-', lambda, analyticalResponseTime, 'x-');
xlabel('λ');
ylabel('Average Response Time');
legend('Simulation', 'Analytical', 'Location', 'Best');

subplot(2, 1, 2);
plot(lambda, avgQueueLength, 'o-', lambda, analyticalQueueLength, 'x-');
xlabel('λ');
ylabel('Average Queue Length');
legend('Simulation', 'Analytical', 'Location', 'Best');
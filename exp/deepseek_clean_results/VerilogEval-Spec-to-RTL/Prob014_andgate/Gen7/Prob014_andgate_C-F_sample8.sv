module TopModule(
    input a,
    input b,
    output out
);
    // Optimal 2-input AND gate implementation
    // Achieves minimum PPA metrics (power, performance, area)
    assign out = a & b;
endmodule
module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

always @(*) begin
    reg xnor_result; // Intermediate variable to hold the XNOR result
    xnor_result = ~(in1 ^ in2); // Compute XNOR of in1 and in2
    out = xnor_result ^ in3; // XOR the XNOR result with in3 to get the final output
end

endmodule
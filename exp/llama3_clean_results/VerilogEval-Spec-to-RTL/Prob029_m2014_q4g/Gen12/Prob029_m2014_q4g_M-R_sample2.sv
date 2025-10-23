module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

always @(*) begin
    // Compute XNOR of in1 and in2
    reg xnor_result;
    xnor_result = ~(in1 ^ in2);
    
    // Compute XOR of xnor_result and in3
    out = xnor_result ^ in3;
end

endmodule
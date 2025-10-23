module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

// Use always block for combinational logic
always @(*) begin
    // Calculate XNOR of in1 and in2
    wire xnor_out = ~(in1 ^ in2);
    
    // Calculate final output by combining XNOR result with XOR operation
    out = xnor_out ^ in3;
end

endmodule
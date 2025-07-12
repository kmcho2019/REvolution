module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

always @(*) begin
    // Perform the XNOR operation
    reg xnor_result;
    xnor_result = (in1 == in2);
    
    // Perform the XOR operation with in3
    out = xnor_result ^ in3;
end

endmodule
module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

reg xnor_tmp;

always @(*) begin
    xnor_tmp = in1 ^~ in2;  // XNOR operation
    out = xnor_tmp ^ in3;   // XOR operation with in3
end

endmodule
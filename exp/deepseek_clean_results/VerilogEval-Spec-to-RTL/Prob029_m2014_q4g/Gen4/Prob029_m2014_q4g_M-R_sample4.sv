module TopModule (
    input in1,
    input in2,
    input in3,
    output reg out
);
    always @(*) begin
        out = (in1 ~^ in2) ^ in3;  // XNOR of in1/in2 then XOR with in3
    end
endmodule
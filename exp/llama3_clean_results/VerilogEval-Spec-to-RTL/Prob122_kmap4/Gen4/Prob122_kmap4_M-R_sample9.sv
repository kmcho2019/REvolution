module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

reg temp_out;

always @(*) begin
    temp_out = a ^ b ^ c ^ d;
    out = temp_out;
end

endmodule
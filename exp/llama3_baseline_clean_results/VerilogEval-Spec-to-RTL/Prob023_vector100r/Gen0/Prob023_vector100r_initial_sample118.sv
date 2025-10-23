module TopModule(
    input [99:0] in,  // 100-bit input
    output [99:0] out // 100-bit output
);

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        out[99 - i] = in[i]; // Assign each bit of out from the opposite end of in
    end
end

endmodule
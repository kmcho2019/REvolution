module TopModule(
    input  [99:0] in,  // 100 bits
    output [99:0] out  // 100 bits
);

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        out[i] = in[99 - i];  // Reverse the bit order
    end
end

endmodule
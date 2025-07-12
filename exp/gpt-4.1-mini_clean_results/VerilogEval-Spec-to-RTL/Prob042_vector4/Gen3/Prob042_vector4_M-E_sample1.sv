module TopModule(
    input  [7:0] in,
    output reg [31:0] out
);

integer i;

always @(*) begin
    // Replicate the sign bit for bits [31:8]
    for (i = 8; i < 32; i = i + 1) begin
        out[i] = in[7];
    end
    // Assign lower 8 bits to input
    out[7:0] = in;
end

endmodule
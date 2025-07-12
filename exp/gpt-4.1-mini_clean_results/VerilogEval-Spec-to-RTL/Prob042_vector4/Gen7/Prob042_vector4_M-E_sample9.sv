module TopModule(
    input  [7:0] in,
    output reg [31:0] out
);

    integer i;
    always @(*) begin
        // Replicate the sign bit to the top 24 bits
        for (i = 31; i >= 8; i = i - 1) begin
            out[i] = in[7];
        end
        // Copy input bits to the lower 8 bits
        for (i = 7; i >= 0; i = i - 1) begin
            out[i] = in[i];
        end
    end

endmodule
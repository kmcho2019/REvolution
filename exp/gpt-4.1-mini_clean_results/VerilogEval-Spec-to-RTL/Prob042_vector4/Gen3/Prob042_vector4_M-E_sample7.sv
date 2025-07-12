module TopModule(
    input  [7:0] in,
    output reg [31:0] out
);
    integer i;
    always @* begin
        // Replicate the sign bit for the upper 24 bits
        for (i = 31; i >= 8; i = i - 1) begin
            out[i] = in[7];
        end
        // Assign the lower 8 bits to the input directly
        out[7:0] = in;
    end
endmodule
module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    integer i;
    always @(*) begin
        // Replicate sign bit into upper 24 bits
        for (i = 31; i >= 8; i = i - 1) begin
            out[i] = in[7];
        end
        // Copy lower 8 bits directly
        out[7:0] = in;
    end

endmodule
module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);
    wire sign_bit = in[7];
    integer i;

    always @(*) begin
        // Replicate the sign bit 24 times for upper bits
        for (i = 31; i >= 8; i = i - 1) begin
            out[i] = sign_bit;
        end
        // Copy the original 8-bit input to lower bits
        out[7:0] = in;
    end
endmodule
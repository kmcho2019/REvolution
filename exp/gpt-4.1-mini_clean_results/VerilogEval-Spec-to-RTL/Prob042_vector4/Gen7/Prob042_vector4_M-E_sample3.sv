module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    integer i;

    always @(*) begin
        // Replicate the sign bit for the upper 24 bits using a loop
        for (i = 31; i >= 8; i = i - 1) begin
            out[i] = in[7];
        end
        // Assign the lower 8 bits directly from input
        out[7:0] = in;
    end

endmodule
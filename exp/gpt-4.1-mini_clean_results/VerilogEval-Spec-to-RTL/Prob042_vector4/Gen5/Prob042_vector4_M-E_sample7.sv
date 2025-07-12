module TopModule (
    input  [7:0] in,
    output reg [31:0] out
);

    integer i;
    always @* begin
        // Assign sign-extended bits [31:8] with the sign bit in[7]
        for (i = 8; i < 32; i = i + 1) begin
            out[i] = in[7];
        end
        // Assign bits [7:0] with the input bits
        for (i = 0; i < 8; i = i + 1) begin
            out[i] = in[i];
        end
    end

endmodule
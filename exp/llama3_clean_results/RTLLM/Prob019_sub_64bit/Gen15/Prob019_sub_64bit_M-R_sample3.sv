module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    reg [63:0] diff;
    reg        overflow_reg;

    always @(*) begin
        diff = A - B;
        overflow_reg = (A[63] == B[63]) && (A[63] != diff[63]);
    end

    assign result = diff;
    assign overflow = overflow_reg;

endmodule
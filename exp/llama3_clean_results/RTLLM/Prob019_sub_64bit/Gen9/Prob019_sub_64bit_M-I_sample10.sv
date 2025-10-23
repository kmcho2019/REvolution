module sub_64bit(
    input  wire clk, // Clock signal for clock gating
    input  wire [63:0] A,
    input  wire [63:0] B,
    output wire [63:0] result,
    output wire        overflow
);

    // Internal signals for clock-gated subtraction
    reg [63:0] sub_result;
    reg        sub_overflow;

    // Perform binary subtraction of A and B with clock gating
    always @(posedge clk) begin
        sub_result <= A - B;
        sub_overflow <= (A[63]!= B[63]) && (A[63]!= (A - B)[63]);
    end

    // Assign outputs
    assign result = sub_result;
    assign overflow = sub_overflow;

endmodule
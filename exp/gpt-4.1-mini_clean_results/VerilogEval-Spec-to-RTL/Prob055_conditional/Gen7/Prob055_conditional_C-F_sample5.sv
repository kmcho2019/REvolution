module TopModule (
    input           clk,
    input           rst_n,
    input      [7:0] a,
    input      [7:0] b,
    input      [7:0] c,
    input      [7:0] d,
    output reg [7:0] min
);

    wire [7:0] min_ab;
    wire [7:0] min_cd;
    wire [7:0] min_comb;

    // Pairwise minimum comparisons (combinational)
    assign min_ab   = (a < b) ? a : b;
    assign min_cd   = (c < d) ? c : d;
    assign min_comb = (min_ab < min_cd) ? min_ab : min_cd;

    // Register the output to reduce glitches and power
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            min <= 8'd0;
        else
            min <= min_comb;
    end

endmodule
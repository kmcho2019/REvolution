module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output reg p1y,
    output reg p2y
);

    // Intermediate signals for AND results
    wire p1_and = p1a & p1b & p1c & p1d;
    wire p2_and = p2a & p2b & p2c & p2d;

    always @(*) begin
        // NAND output is inverse of AND of inputs
        p1y = ~p1_and;
        p2y = ~p2_and;
    end

endmodule
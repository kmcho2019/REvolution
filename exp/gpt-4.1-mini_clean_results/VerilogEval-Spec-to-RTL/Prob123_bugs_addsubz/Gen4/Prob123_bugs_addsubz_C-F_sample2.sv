module TopModule (
    input             clk,
    input             do_sub,
    input      [7:0]  a,
    input      [7:0]  b,
    output reg [7:0]  out,
    output reg        result_is_zero
);

    wire [7:0] b_mux;
    wire [7:0] sum;

    // Two's complement subtraction via inversion and carry-in
    assign b_mux = do_sub ? ~b : b;
    assign sum   = a + b_mux + do_sub;

    // Register outputs on clock edge to reduce glitches and improve timing
    always @(posedge clk) begin
        out <= sum;
        result_is_zero <= (sum == 8'b0);
    end

endmodule
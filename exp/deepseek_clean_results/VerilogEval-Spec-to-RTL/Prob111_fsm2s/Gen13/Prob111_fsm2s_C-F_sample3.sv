module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // Clear state encoding with optimal binary representation
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Compact state transition with clear priority ordering
    always @(posedge clk) begin
        state <= reset ? OFF : (state == ON) ? (k ? OFF : ON) : (j ? ON : OFF);
    end

    // Direct state-to-output assignment for minimal logic
    assign out = state;

endmodule
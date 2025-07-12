module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Synchronous reset for improved timing and power
    always @(posedge clk) begin
        if (areset)
            state <= OFF;
        else
            state <= (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end

    // Output follows state directly (Moore output)
    assign out = state;

endmodule
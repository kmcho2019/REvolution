module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // State transition and synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end

    // Output assignment
    assign out = state;

endmodule
module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // Define states
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    reg state;

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= OFF;
        else
            state <= (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == ON);

endmodule
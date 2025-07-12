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
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                        (state == ON)  ? (k ? OFF : ON) :
                        OFF; // default case (shouldn't occur)

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore: output depends only on state)
    assign out = (state == ON);

endmodule
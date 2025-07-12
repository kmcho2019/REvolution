module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                       (state == ON)  ? (k ? OFF : ON) :
                       OFF;  // default case (should never occur)

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic
    assign out = state;

endmodule
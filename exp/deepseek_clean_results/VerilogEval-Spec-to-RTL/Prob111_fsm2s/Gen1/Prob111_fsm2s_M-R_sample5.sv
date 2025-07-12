module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // Define states
    parameter OFF = 1'b0;
    parameter ON  = 1'b1;

    // State register and next state wire
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = (state == OFF) ? (j ? ON : OFF) :
                       (state == ON)  ? (k ? OFF : ON) :
                       OFF; // Default case (shouldn't occur)

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output is directly the state (Moore machine)
    assign out = state;

endmodule
module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding using localparam enum
    localparam OFF = 1'b0, ON = 1'b1;
    reg state;

    wire next_state;

    // Next state logic as continuous assignment
    assign next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

    // Output logic (Moore)
    assign out = (state == ON);

    // State update with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else if (state != next_state) begin
            state <= next_state;
        end
        // else hold current state (no toggling)
    end

endmodule
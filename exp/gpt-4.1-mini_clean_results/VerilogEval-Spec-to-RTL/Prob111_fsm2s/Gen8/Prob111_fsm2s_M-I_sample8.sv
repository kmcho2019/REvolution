module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    localparam OFF = 1'b0, ON = 1'b1;
    reg state, next_state;

    // Combined next state and output logic in one always block with blocking assignments
    always @(*) begin
        if (state == OFF)
            next_state = j ? ON : OFF;
        else
            next_state = k ? OFF : ON;
    end

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output is combinational and directly from state (Moore machine)
    assign out = (state == ON);

endmodule
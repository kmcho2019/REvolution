module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;

    // Next state logic as continuous assignment
    wire next_state = (state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

    // Sequential block with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    // Output depends only on state (Moore FSM)
    assign out = (state == ON);

endmodule
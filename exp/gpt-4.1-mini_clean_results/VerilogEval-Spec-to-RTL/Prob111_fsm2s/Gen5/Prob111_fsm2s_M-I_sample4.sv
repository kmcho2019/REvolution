module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // State encoding using parameters
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        case(state)
            OFF: next_state = (j == 1'b1) ? ON : OFF;
            ON:  next_state = (k == 1'b1) ? OFF : ON;
            default: next_state = OFF;
        endcase
    end

    // Clock gating enable: allow state update only if reset asserted or state will change
    wire clk_en = reset | (state != next_state);

    // Gated clock generation
    wire gated_clk = clk & clk_en;

    // State register with synchronous reset on gated clock
    always @(posedge gated_clk) begin
        if (reset)
            state <= OFF;
        else
            state <= next_state;
    end

    // Output logic (Moore): output depends only on state
    assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule
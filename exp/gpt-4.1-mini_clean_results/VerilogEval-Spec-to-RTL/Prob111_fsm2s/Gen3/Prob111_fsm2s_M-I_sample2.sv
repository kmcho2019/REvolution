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
    wire clk_en;

    // Next state logic (combinational) with explicit if-else for clarity
    always @(*) begin
        if (state == OFF) begin
            if (j == 1'b1)
                next_state = ON;
            else
                next_state = OFF;
        end else begin // state == ON
            if (k == 1'b1)
                next_state = OFF;
            else
                next_state = ON;
        end
    end

    // Clock enable logic for state register: enable clock only when state change occurs or during reset
    assign clk_en = reset | (next_state != state);

    // Gated clock generation
    wire gated_clk;
    // Simple AND gate for gating clock - note: in real ASIC, use proper clock gating cells
    assign gated_clk = clk & clk_en;

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
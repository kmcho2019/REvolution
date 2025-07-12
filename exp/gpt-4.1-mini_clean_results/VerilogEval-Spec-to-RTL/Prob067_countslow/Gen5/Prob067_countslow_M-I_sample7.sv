module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    wire [3:0] q_next;
    wire gated_clk;

    // Combinational next-state logic using assign and ternary operator
    assign q_next = (q == 4'd9) ? 4'd0 : (q + 4'd1);

    // Clock gating enable: active when counting (slowena=1) and not resetting
    wire clk_enable = slowena & ~reset;

    // Simple clock gating by ANDing clock with enable
    assign gated_clk = clk & clk_enable;

    // Sequential logic with synchronous reset and gated clock
    // Note: gated clock reduces power by disabling toggles when not counting
    always @(posedge gated_clk or posedge reset) begin
        if (reset)
            q <= 4'd0;
        else
            q <= q_next;
    end

endmodule
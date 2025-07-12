module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State tracking registers with clock gating
    reg prev1, prev2;  // Stores previous two input values
    wire clk_enable = (x ^ prev1) || !aresetn;  // Enable clock when input changes or during reset

    // Clock gating cell
    wire gated_clk;
    CLK_GATE clk_gate (
        .CLK(clk),
        .EN(clk_enable),
        .GCLK(gated_clk)
    );

    // Sequential logic with async reset and clock gating
    always @(posedge gated_clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else begin
            // Shift register behavior
            prev2 <= prev1;
            prev1 <= x;
        end
    end

    // Mealy output logic - detects '101' pattern
    assign z = prev2 & ~prev1 & x;

endmodule

// Clock gating cell definition
module CLK_GATE (
    input CLK,
    input EN,
    output GCLK
);
    // Standard clock gating cell implementation
    reg en_latch;
    always @(*) begin
        if (!CLK) en_latch = EN;
    end
    assign GCLK = CLK & en_latch;
endmodule
module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State tracking registers
    reg prev1, prev2;  // Stores previous two input values
    reg x_prev;        // For clock gating detection

    // Clock gating signal
    wire x_changed = (x != x_prev);
    wire gated_clk = clk & (x_changed | !aresetn);

    // Sequential logic with async reset and clock gating
    always @(posedge gated_clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
            x_prev <= 1'b0;
            z <= 1'b0;
        end else begin
            // Shift register behavior
            prev2 <= prev1;
            prev1 <= x;
            x_prev <= x;
            // Mealy output logic - detects '101' pattern
            z <= prev2 & ~prev1 & x;
        end
    end

endmodule
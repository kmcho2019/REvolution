module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State tracking registers with clock gating
    reg prev1, prev2;  // Stores previous two input values
    wire clk_enable = (x ^ prev1) | (x ^ prev2); // Enable when input changes

    // Sequential logic with async reset and clock gating
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else if (clk_enable) begin
            // Shift register behavior only when needed
            prev2 <= prev1;
            prev1 <= x;
        end
    end

    // Mealy output logic - detects '101' pattern
    assign z = prev2 & ~prev1 & x;

endmodule
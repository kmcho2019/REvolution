module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State tracking registers
    reg prev1, prev2;  // Stores previous two input values

    // Sequential logic with async reset
    always @(posedge clk or negedge aresetn) begin
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
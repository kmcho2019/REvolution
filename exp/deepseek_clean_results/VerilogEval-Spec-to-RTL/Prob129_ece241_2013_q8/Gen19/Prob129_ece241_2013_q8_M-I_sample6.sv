module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State tracking registers with clock gating
    reg prev1, prev2;  // Stores previous two input values
    reg x_stable;      // Tracks if input x has changed
    
    // Clock gating logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_stable <= 1'b0;
        end else begin
            x_stable <= (x == prev1);  // Detect if input is stable
        end
    end

    // Sequential logic with async reset and clock gating
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else if (!x_stable) begin  // Only update when input changes
            prev2 <= prev1;
            prev1 <= x;
        end
    end

    // Mealy output logic - detects '101' pattern
    assign z = prev2 & ~prev1 & x;

endmodule
module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg prev1, prev2;  // Stores previous two x values (clear naming)

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else begin
            prev2 <= prev1;  // Shift register behavior
            prev1 <= x;
        end
    end

    // Mealy output: depends on current state (prev2, prev1) and input x
    // Detects pattern "101" (prev2=1, prev1=0, x=1)
    assign z = prev2 & ~prev1 & x;

endmodule
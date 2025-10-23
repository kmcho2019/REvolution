module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg prev1, prev2;  // Single bit registers for previous two states
    reg x_stable;      // Track if input is stable
    reg x_prev;        // Previous input value for change detection

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
            z <= 1'b0;
            x_stable <= 1'b0;
            x_prev <= 1'b0;
        end else begin
            x_prev <= x;
            x_stable <= (x == x_prev);  // Clock gating condition
            
            if (!x_stable) begin  // Only update when input changes
                prev2 <= prev1;
                prev1 <= x;
            end
            
            // Registered output improves timing
            z <= prev2 & ~prev1 & x;  // Detect pattern 1-0-1
        end
    end

endmodule
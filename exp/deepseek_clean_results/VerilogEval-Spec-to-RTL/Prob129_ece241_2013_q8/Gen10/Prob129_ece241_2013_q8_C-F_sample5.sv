module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg prev1, prev2;  // Track previous two bits

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else begin
            prev2 <= prev1;
            prev1 <= x;
        end
    end

    // Detect '1' (prev2), '0' (prev1), '1' (current x)
    assign z = prev2 & ~prev1 & x;

endmodule
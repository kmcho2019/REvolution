module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg prev1, prev2;  // Single bit registers for previous two states

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            prev1 <= 1'b0;
            prev2 <= 1'b0;
        end else begin
            prev2 <= prev1;
            prev1 <= x;
        end
    end

    assign z = prev2 & ~prev1 & x;  // Detect pattern 1-0-1

endmodule
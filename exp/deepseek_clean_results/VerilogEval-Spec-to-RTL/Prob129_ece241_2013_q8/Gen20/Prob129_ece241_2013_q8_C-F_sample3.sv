module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg x_prev1, x_prev2;  // Stores previous two x values (x_prev2 is older)

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_prev1 <= 1'b0;
            x_prev2 <= 1'b0;
        end else begin
            x_prev2 <= x_prev1;
            x_prev1 <= x;
        end
    end

    // Mealy output: detects pattern '1' (x_prev2), '0' (x_prev1), '1' (current x)
    assign z = x_prev2 & ~x_prev1 & x;

endmodule
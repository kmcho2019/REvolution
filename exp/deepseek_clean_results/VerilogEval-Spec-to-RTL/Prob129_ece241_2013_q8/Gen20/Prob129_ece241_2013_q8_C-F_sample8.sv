module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg x_prev, x_prev_prev;  // Stores previous two x values

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_prev <= 1'b0;
            x_prev_prev <= 1'b0;
        end else begin
            x_prev_prev <= x_prev;  // Shift operation
            x_prev <= x;
        end
    end

    // Mealy output: detect "101" pattern (x_prev_prev=1, x_prev=0, x=1)
    assign z = x_prev_prev & ~x_prev & x;

endmodule
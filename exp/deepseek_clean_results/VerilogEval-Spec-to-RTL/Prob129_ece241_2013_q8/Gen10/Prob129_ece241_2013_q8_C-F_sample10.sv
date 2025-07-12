module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg x_prev, x_prev_prev;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_prev <= 1'b0;
            x_prev_prev <= 1'b0;
        end else begin
            x_prev_prev <= x_prev;
            x_prev <= x;
        end
    end

    assign z = x_prev_prev & ~x_prev & x;

endmodule
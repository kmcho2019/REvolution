module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    // Create delayed version of 'a' using clock-gated assignment
    wire a_delayed;
    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
        end else begin
            a_prev <= a;
        end
    end

    assign a_delayed = a_prev;

    // Edge detection logic
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule
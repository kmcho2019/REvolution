module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    reg a_delayed = 1'b0;

    // Register implementation using continuous assignment
    assign a_prev = a_delayed;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_delayed <= 1'b0;
        end else begin
            a_delayed <= a;
        end
    end

    // Edge detection logic
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule
module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    wire a_prev;
    reg a_prev_reg;

    // Clocked assignment for the previous value
    assign a_prev = a_prev_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev_reg <= 1'b0;
        else
            a_prev_reg <= a;
    end

    // Edge detection logic
    assign rise = ~a_prev & a;
    assign down = a_prev & ~a;

endmodule
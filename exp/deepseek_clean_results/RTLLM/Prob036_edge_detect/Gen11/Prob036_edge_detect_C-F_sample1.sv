module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

    reg a_prev;

    // Registered storage of previous value with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else
            a_prev <= a;
    end

    // Combinational edge detection
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule
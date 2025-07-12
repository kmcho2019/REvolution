module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output wire rise,
    output wire down
);

    reg a_prev;

    wire ce = (a != a_prev);  // clock enable when input 'a' changes

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_prev <= 1'b0;
        else if (ce)
            a_prev <= a;
    end

    assign rise = (~a_prev) & a;
    assign down = a_prev & (~a);

endmodule
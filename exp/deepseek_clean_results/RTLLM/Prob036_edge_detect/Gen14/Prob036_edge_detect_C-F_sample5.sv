module edge_detect (
    input clk,
    input rst_n,  // Interface compatibility only
    input a,
    output rise,
    output down
);

    reg a_delayed = 1'b0;  // Initialized to 0 (simulation only)

    always @(posedge clk) begin
        a_delayed <= a;
    end

    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule
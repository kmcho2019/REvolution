module edge_detect (
    input clk,
    input a,
    output rise,
    output down
);

    reg a_delayed;

    // Single flip-flop to store previous value
    always @(posedge clk) begin
        a_delayed <= a;
    end

    // Edge detection using simple AND gates
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule
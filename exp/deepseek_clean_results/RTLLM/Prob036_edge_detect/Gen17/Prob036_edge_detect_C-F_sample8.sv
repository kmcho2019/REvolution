module edge_detect (
    input clk,
    input a,
    output rise,
    output down
);

    reg a_delayed = 1'b0;  // Initialized for simulation

    always @(posedge clk) begin
        a_delayed <= a;
    end

    // Efficient gate-level edge detection
    assign rise = a & ~a_delayed;
    assign down = ~a & a_delayed;

endmodule
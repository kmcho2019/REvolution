module edge_detect (
    input clk,
    input rst_n,  // Kept for interface compatibility
    input a,
    output rise,
    output down
);

    wire a_prev;
    reg a_delayed = 1'b0;

    // Delay element using continuous assignment
    assign a_prev = a_delayed;

    // Update delayed value on clock edge
    always @(posedge clk) begin
        a_delayed <= a;
    end

    // Edge detection remains combinational
    assign rise = a & ~a_prev;
    assign down = ~a & a_prev;

endmodule
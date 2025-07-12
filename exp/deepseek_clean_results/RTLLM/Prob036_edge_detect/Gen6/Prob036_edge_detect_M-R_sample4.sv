module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

wire a_prev;

// Create delayed version of 'a' using continuous assignment
assign #1 a_prev = a;

// Reset handling - initialize the delayed signal
initial begin
    a_prev = 1'b0;
end

// Edge detection logic remains the same
assign rise = ~a_prev & a;
assign down = a_prev & ~a;

endmodule
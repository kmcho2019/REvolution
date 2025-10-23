module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Implement the D flip-flop directly in TopModule using always block
    // triggered on positive edge of clk with nonblocking assignment
    always @(posedge clk)
        q <= d;
endmodule
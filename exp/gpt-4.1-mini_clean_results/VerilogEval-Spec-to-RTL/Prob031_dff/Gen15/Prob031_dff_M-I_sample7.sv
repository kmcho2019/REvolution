// Top-level module implementing a single D flip-flop directly
module TopModule (
    input  wire clk,
    input  wire d,
    output reg  q
);
    // Sequential logic: positive edge triggered D flip-flop with nonblocking assignment
    always @(posedge clk) begin
        q <= d;
    end
endmodule
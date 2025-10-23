module TopModule(
    input clk,
    input a,
    output reg q
);

// Initial state
initial q = 1'b1;

// Alternative implementation using a continuous assignment for combinational part
// and an always block for the sequential part
wire d;
assign d = ~a;

always @(posedge clk) 
    q <= d;

endmodule
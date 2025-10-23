module TopModule (
    input  wire clk,
    input  wire ar,
    input  wire d,
    output wire q
);

wire n1, n2, n3, n4, q_bar;
wire delayed_clk;

// Clock delay for edge detection (conceptual)
assign #1 delayed_clk = clk;

// Asynchronous reset path
assign n1 = ar ? 1'b0 : n4;

// Master latch
assign n2 = ~(delayed_clk & n1);
assign n3 = ~(~delayed_clk & d);

// Slave latch
assign n4 = ~(n2 & q_bar);
assign q_bar = ~(clk & n3);

// Output assignment
assign q = ~q_bar;

endmodule
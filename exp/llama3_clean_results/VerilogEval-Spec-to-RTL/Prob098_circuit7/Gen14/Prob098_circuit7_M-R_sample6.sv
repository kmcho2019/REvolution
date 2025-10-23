module TopModule(
    input clk,
    input a,
    output reg q
);

// Explicitly define the reset condition for the flip-flop
initial q = 1'b0; // Initialize q to 0 at power-up

always @(posedge clk)
    q <= ~a; // Assign the inverse of 'a' to 'q' on the positive edge of 'clk'

endmodule
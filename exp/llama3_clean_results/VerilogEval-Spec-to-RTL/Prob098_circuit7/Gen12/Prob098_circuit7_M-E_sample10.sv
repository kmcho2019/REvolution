module TopModule(
    input clk,
    input a,
    output reg q = 1'b1 // Initial state to match simulation
);

always @(posedge clk) 
    q <= ~a ? ~q : 1'b0; // Toggled based on a, with initial high state

endmodule
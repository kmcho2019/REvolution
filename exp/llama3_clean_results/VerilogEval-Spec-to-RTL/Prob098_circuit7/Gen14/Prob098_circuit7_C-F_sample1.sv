module TopModule(
    input clk,
    input a,
    output reg q
);

// This module implements a simple sequential circuit that assigns the inverted input 'a' to the output 'q' on the positive edge of the clock 'clk'.
always @(posedge clk) begin
    q <= !a; // Using !a for inversion to match the problem's logic
end

endmodule
module TopModule (
    input        clk,     // Clock input, positive edge triggered
    input        areset,  // Asynchronous reset, active high
    input  [7:0] d,       // 8-bit data input
    output reg [7:0] q    // 8-bit output register
);

// 8 D flip-flops with active-high asynchronous reset
// On posedge clk, q captures d if not in reset
// On posedge areset, q asynchronously resets to zero
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 8'b0;
    else
        q <= d;
end

endmodule
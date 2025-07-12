// Top-level module implementing 8 D flip-flops with active high asynchronous reset.
// Each flip-flop asynchronously resets to 0 when areset is high and captures the corresponding
// bit of input 'd' on the rising edge of 'clk'.

module TopModule (
    input        clk,    // Clock input (positive edge triggered)
    input        areset, // Asynchronous reset (active high)
    input  [7:0] d,      // 8-bit data input
    output reg [7:0] q   // 8-bit data output
);

    integer i;

    // Use a generate-style for loop with combinational always block style
    // but since asynchronous reset and clock edge sensitive, use always @*
    // cannot do generate for always block, so do a single always with bit-wise logic.

    // Asynchronous reset and positive edge clock sequential logic for 8 bits.
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end

endmodule
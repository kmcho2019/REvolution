module TopModule (
    input        clk,
    input        areset,
    input  [7:0] d,
    output reg [7:0] q
);

// 8-bit register with active-high asynchronous reset
// On reset, outputs are cleared to zero asynchronously.
// On rising edge of clk, data input is loaded into register.
always @(posedge clk or posedge areset) begin
    if (areset)
        q <= 8'b0;
    else
        q <= d;
end

endmodule
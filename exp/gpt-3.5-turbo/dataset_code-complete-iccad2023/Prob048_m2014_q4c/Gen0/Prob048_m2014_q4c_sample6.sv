module D_ff_with_reset (
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk)
begin
    if (r)
        q <= 0;  // Reset the output to 0 when the reset signal is high
    else
        q <= d;  // Update the output with the input on positive clock edge
end

endmodule
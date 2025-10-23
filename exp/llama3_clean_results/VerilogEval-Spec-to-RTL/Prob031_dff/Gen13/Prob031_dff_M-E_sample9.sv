module TopModule(
    input clk,
    input d,
    output reg q
);

// Internal signals for the NAND gate implementation
reg s, r, q_bar;

// NAND gate implementation for the SR latch
always @(*)
begin
    s = ~(~clk & ~d);
    r = ~(~clk & q);
    q_bar = ~(s & r);
    q = ~(~q_bar & ~r);
end

// Assign the output of the flip-flop directly to the output port
always @(posedge clk)
    q <= d;

endmodule
module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

wire nextQ;
wire update_enable;

// Canonical JK flip-flop characteristic equation
assign nextQ = (j & ~Q) | (~k & Q);

// Enable update only when J or K is high to prevent unnecessary toggling
assign update_enable = j | k;

always @(posedge clk) begin
    if (update_enable)
        Q <= nextQ;
end

endmodule
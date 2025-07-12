module TopModule(
    input  clk,
    input  d,
    output q
    );

reg q_int;
reg q_int2;
reg clk_inv;

// Invert the clock signal
assign clk_inv = ~clk;

// Single-edge triggered flip-flop on the positive edge
always @(posedge clk)
begin
    q_int <= d;
end

// Single-edge triggered flip-flop on the inverted clock (negative edge of original clock)
always @(posedge clk_inv)
begin
    q_int2 <= d;
end

// Select the output of either flip-flop based on the current edge of the clock
always @(posedge clk or posedge clk_inv)
begin
    if (clk)
        q <= q_int;
    else
        q <= q_int2;
end

endmodule
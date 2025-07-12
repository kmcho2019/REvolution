module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

reg prev_clock;
initial prev_clock = 0;

always @(*)
begin
    if (clock == 1 && prev_clock == 0) // when clock goes high
        q <= 0; // reset q
    else if (clock == 1)
        q <= a; // when clock is high, q follows a
    
    prev_clock <= clock; // keep track of previous clock value
end

assign p = clock && a; // p is AND of clock and a

endmodule
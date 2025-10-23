module TopModule(
    input  d,
    input  ena,
    output reg q
);

always @(d, ena) begin
    if (ena) 
        q = d;
    else
        q <= q; // Using non-blocking for retention, though it doesn't affect the latch behavior here
end

endmodule
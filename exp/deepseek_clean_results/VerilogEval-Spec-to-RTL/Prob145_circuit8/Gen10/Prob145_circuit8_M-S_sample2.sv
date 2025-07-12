module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p simply follows 'a' during clock high
    
    // q remembers previous p until 'a' goes high again
    if (a)
        q <= 0;
    else if (p)
        q <= 1;
end

endmodule
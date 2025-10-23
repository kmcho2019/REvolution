module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg p_prev;

always @(posedge clock) begin
    p <= a;
    p_prev <= p;
    
    if (p && p_prev)  // p has been 1 for two consecutive cycles
        q <= 1;
    else if (!p)       // p is 0
        q <= 0;
end

endmodule
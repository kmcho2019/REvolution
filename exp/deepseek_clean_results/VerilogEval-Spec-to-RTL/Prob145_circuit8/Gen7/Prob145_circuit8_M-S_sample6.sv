module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p is registered version of (clock & a)
always @(posedge clock) begin
    p <= clock & a;
end

// q is 1-cycle delayed version of p with async clear
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock)
        q <= 1'b0;
    else
        q <= p;
end

endmodule
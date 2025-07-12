module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

// p captures 'a' at positive clock edges
always @(posedge clock) begin
    p <= a;
end

// q is 1-cycle delayed version of p with async clear
always @(posedge clock or posedge (a & ~clock)) begin
    if (a & ~clock)
        q <= 1'b0;
    else
        q <= p;
end

endmodule
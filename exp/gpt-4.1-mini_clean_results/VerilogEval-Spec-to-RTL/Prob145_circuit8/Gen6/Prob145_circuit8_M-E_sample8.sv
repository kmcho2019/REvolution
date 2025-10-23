module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

// At rising edge, p follows 'a' only if q is 1, otherwise p is forced to 0
always @(posedge clock) begin
    if (q)
        p <= a;
    else
        p <= 1'b0;
end

// At falling edge, q captures p
always @(negedge clock) begin
    q <= p;
end

endmodule
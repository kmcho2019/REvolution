module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;  // p directly follows 'a' at positive edges
end

always @(negedge clock) begin
    if (a) q <= p;  // q follows p only when 'a' is high at negative edge
end

initial begin
    p = 1'b0;
    q = 1'b0;
end

endmodule
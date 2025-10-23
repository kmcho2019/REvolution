module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

// No initial block: p and q start as unknown (x)

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    q <= p;
end

endmodule
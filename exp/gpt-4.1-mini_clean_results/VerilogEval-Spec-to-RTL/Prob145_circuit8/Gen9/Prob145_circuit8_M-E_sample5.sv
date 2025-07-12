module TopModule(
    input  clock,
    input  a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

// Sample 'a' at posedge clock into p
always @(posedge clock) begin
    p <= a;
end

// Capture p at negedge clock into q
always @(negedge clock) begin
    q <= p;
end

endmodule
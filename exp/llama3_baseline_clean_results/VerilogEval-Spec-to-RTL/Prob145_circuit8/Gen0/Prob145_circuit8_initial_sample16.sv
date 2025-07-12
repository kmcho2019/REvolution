module TopModule(
    input  wire clock,
    input  wire a,
    output reg  p,
    output reg  q
);

always @(posedge clock) begin
    p <= a;
    q <= q | p;
end

always @(negedge clock) begin
    q <= p;
end

endmodule
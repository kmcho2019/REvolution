module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

always @(posedge clock) begin
    p <= a;          // p is a sampled on rising clock edge
    q <= p;          // q is p delayed by one clock cycle
end

endmodule
module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'b0;
    q = 1'b0;
end

always @(posedge clock) begin
    p <= a;
end

always @(negedge clock) begin
    q <= p;
end

endmodule
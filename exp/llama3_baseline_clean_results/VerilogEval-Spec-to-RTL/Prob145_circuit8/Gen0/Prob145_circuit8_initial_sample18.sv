module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg prev_p;

always @(posedge clock) begin
    prev_p <= p;
    p <= a;
end

always @(negedge clock) begin
    q <= prev_p;
end

initial begin
    p = 0;
    q = 0;
end

endmodule
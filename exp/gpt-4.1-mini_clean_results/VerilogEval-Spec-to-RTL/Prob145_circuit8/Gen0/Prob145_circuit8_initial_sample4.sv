module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 1'bx;
    q = 1'bx;
end

always @(posedge clock) begin
    p <= a;
    // q holds its value at posedge
end

always @(negedge clock) begin
    q <= p;
    // p holds its value at negedge
end

endmodule
module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

// p samples input a on rising clock edge
always @(posedge clock) begin
    p <= a;
end

// q samples p on falling clock edge
always @(negedge clock) begin
    q <= p;
end

endmodule
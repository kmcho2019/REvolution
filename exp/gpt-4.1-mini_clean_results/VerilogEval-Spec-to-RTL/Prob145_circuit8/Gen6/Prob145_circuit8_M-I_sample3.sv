module TopModule(
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
    p <= a;    // Sample input a on rising edge
end

always @(negedge clock) begin
    q <= p;    // Sample p on falling edge, introducing half-cycle delay
end

endmodule
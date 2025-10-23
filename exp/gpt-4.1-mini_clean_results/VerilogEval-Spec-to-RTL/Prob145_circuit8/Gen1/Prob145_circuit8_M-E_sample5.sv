module TopModule(
    input wire clock,
    input wire a,
    output reg p,
    output reg q
);

initial begin
    p = 0;
    q = 0;
end

// Combinational logic for p: if clock=1 output a; else output stored q
always @(*) begin
    p = clock ? a : q;
end

// Sequential logic: on falling edge of clock, capture p into q
always @(negedge clock) begin
    q <= p;
end

endmodule
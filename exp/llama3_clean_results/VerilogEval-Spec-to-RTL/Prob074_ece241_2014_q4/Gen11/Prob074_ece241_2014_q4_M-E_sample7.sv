// DFlipFlop module
module DFlipFlop(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

// GateLogic module
module GateLogic(
    input x,
    input xor_q,
    input and_q,
    input or_q,
    output xor_out,
    output and_out,
    output or_out,
    output z
);

assign xor_out = x ^ xor_q;
assign and_out = x & ~and_q;
assign or_out = x | ~or_q;
assign z = ~(xor_out | and_out | or_out);

endmodule

// TopModule
module TopModule(
    input clk,
    input x,
    output z
);

reg xor_q = 0, and_q = 0, or_q = 0;
wire xor_out, and_out, or_out;

DFlipFlop xor_ff(
    .clk(clk),
    .d(xor_out),
    .q(xor_q)
);

DFlipFlop and_ff(
    .clk(clk),
    .d(and_out),
    .q(and_q)
);

DFlipFlop or_ff(
    .clk(clk),
    .d(or_out),
    .q(or_q)
);

GateLogic gate_logic(
    .x(x),
    .xor_q(xor_q),
    .and_q(and_q),
    .or_q(or_q),
    .xor_out(xor_out),
    .and_out(and_out),
    .or_out(or_out),
    .z(z)
);

endmodule
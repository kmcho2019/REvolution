// Gate modules
module xor_gate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

module and_gate(
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module or_gate(
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule

// D flip-flop module
module d_flip_flop(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Top-level module
module TopModule(
    input clk,
    input x,
    output z
);
    wire xor_out, and_out, or_out;
    reg xor_state, and_state, or_state;

    // Instantiate gate modules
    xor_gate xor_g(.a(x), .b(xor_state), .out(xor_out));
    and_gate and_g(.a(x), .b(~and_state), .out(and_out));
    or_gate or_g(.a(x), .b(~or_state), .out(or_out));

    // Instantiate D flip-flop modules
    d_flip_flop xor_ff(.clk(clk), .d(xor_out), .q(xor_state));
    d_flip_flop and_ff(.clk(clk), .d(and_out), .q(and_state));
    d_flip_flop or_ff(.clk(clk), .d(or_out), .q(or_state));

    // Calculate final output z
    assign z = ~(xor_state | and_state | or_state);
endmodule
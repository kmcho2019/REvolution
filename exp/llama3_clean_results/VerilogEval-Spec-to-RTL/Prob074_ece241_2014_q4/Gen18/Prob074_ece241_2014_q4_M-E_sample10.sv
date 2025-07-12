module TopModule(
    input clk,
    input x,
    output z
);

// Define the D flip-flop module
module d_flip_flop(
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

// Define the gate modules
module xor_gate(
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule

module and_gate(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module or_gate(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// Define the NOR gate module
module nor_gate(
    input a,
    input b,
    input c,
    output y
);
    assign y = ~(a | b | c);
endmodule

// Instantiate the D flip-flops and gates
wire xor_out, and_out, or_out;
reg q_xor, q_and, q_or;
d_flip_flop xor_ff(clk, xor_out, q_xor);
d_flip_flop and_ff(clk, and_out, q_and);
d_flip_flop or_ff(clk, or_out, q_or);

xor_gate xor_inst(x, q_xor, xor_out);
and_gate and_inst(x, ~q_and, and_out);
or_gate or_inst(x, ~q_or, or_out);

// Compute the final output 'z'
nor_gate nor_inst(q_xor, q_and, q_or, z);

endmodule
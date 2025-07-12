// XOR gate module
module xor_gate(
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule

// AND gate module
module and_gate(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

// OR gate module
module or_gate(
    input a,
    input b,
    output y
);
    assign y = a | b;
endmodule

// NOR gate module
module nor_gate(
    input a,
    input b,
    input c,
    output y
);
    assign y = ~(a | b | c);
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
    wire xor_out;
    wire and_out;
    wire or_out;
    reg q1 = 1'b0; // initialize q1 to 0
    reg q2 = 1'b0; // initialize q2 to 0
    reg q3 = 1'b0; // initialize q3 to 0

    // Instantiate XOR gate
    xor_gate xor_gate_inst(
       .a(x),
       .b(q1),
       .y(xor_out)
    );

    // Instantiate AND gate
    and_gate and_gate_inst(
       .a(x),
       .b(~q2),
       .y(and_out)
    );

    // Instantiate OR gate
    or_gate or_gate_inst(
       .a(x),
       .b(~q3),
       .y(or_out)
    );

    // Instantiate D flip-flops
    d_flip_flop d_flip_flop_inst1(
       .clk(clk),
       .d(xor_out),
       .q(q1)
    );

    d_flip_flop d_flip_flop_inst2(
       .clk(clk),
       .d(and_out),
       .q(q2)
    );

    d_flip_flop d_flip_flop_inst3(
       .clk(clk),
       .d(or_out),
       .q(q3)
    );

    // Instantiate NOR gate
    nor_gate nor_gate_inst(
       .a(q1),
       .b(q2),
       .c(q3),
       .y(z)
    );
endmodule
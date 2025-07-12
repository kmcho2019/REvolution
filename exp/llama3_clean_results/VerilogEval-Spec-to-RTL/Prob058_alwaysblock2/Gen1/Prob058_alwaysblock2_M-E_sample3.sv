// Define a separate module for the XOR gate
module xor_gate(
    input a,
    input b,
    output out
);
    
    assign out = a ^ b;
    
endmodule

// Define a module for the flip-flop
module flip_flop(
    input clk,
    input d,
    output reg q
);
    
    always @(posedge clk) begin
        q = d;
    end
    
endmodule

// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    
    // Instantiate the XOR gate for out_assign and out_always_comb
    xor_gate u_xor1(
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    wire internal_xor;
    xor_gate u_xor2(
        .a(a),
        .b(b),
        .out(internal_xor)
    );
    
    assign out_always_comb = internal_xor;
    
    // Instantiate the flip-flop for out_always_ff
    wire internal_xor_ff;
    xor_gate u_xor3(
        .a(a),
        .b(b),
        .out(internal_xor_ff)
    );
    
    flip_flop u_ff(
        .clk(clk),
        .d(internal_xor_ff),
        .q(out_always_ff)
    );
    
endmodule
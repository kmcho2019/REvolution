// Define a separate module for the XOR gate
module xor_gate(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Instantiate the XOR gate for out_assign
    xor_gate u_xor1(
       .a(a),
       .b(b),
       .out(out_assign)
    );
    
    // Directly implement the combinational logic for out_always_comb
    // But to maintain modularity, we can still use the xor_gate module
    xor_gate u_xor2(
       .a(a),
       .b(b),
       .out(out_always_comb)
    );
    
    // Implement the flip-flop logic directly for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule
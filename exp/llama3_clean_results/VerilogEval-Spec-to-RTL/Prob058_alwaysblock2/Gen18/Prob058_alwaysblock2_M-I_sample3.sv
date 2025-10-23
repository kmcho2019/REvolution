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
    
    // Instantiate the XOR gate and reuse its output for both out_assign and out_always_comb
    wire xor_out;
    xor_gate u_xor(
      .a(a),
      .b(b),
      .out(xor_out)
    );
    
    assign out_assign = xor_out;
    assign out_always_comb = xor_out;
    
    // Implement the flip-flop logic directly for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
endmodule
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
    
    always_ff @(posedge clk) begin
        q <= d; // Use non-blocking assignment to prevent race conditions
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
    wire internal_xor;
    xor_gate u_xor(
      .a(a),
      .b(b),
      .out(internal_xor)
    );
    
    // Directly assign the result for out_assign
    assign out_assign = internal_xor;
    
    // Use a combinational always block for out_always_comb
    always_comb begin
        out_always_comb = internal_xor;
    end
    
    // Instantiate the flip-flop for out_always_ff
    flip_flop u_ff(
      .clk(clk),
      .d(internal_xor),
      .q(out_always_ff)
    );
    
endmodule
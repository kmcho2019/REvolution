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
    
    // Instantiate the XOR gate
    wire internal_xor;
    xor_gate u_xor(
       .a(a),
       .b(b),
       .out(internal_xor)
    );
    
    // Directly assign the result for out_assign and out_always_comb
    assign out_assign = internal_xor;
    assign out_always_comb = internal_xor;
    
    // Use an always_ff block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= internal_xor; // Use non-blocking assignment to prevent race conditions
    end
    
endmodule
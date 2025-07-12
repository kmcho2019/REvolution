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
    
    // Instantiate the XOR gate and reuse its output
    wire internal_xor;
    xor_gate u_xor(
       .a(a),
       .b(b),
       .out(internal_xor)
    );
    
    // Directly assign the result for out_assign
    assign out_assign = internal_xor;
    
    // Use always_comb for the combinational always block
    always_comb begin
        out_always_comb = internal_xor;
    end
    
    // Use always_ff for the clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= internal_xor;
    end
    
endmodule
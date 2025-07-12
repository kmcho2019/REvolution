// Define a module for the combinational XOR gate
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
    
    // Instantiate the combinational XOR gate for out_assign
    xor_gate u_assign(
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    // Instantiate the combinational XOR gate for out_always_comb
    xor_gate u_always_comb(
        .a(a),
        .b(b),
        .out(out_always_comb)
    );
    
    // Clocked always block for out_always_ff using a latch-based approach
    reg latch_out;
    always @(posedge clk) begin
        latch_out <= a ^ b;
    end
    
    assign out_always_ff = latch_out;
    
endmodule
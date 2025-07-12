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
    
    // Instantiate the XOR gate for out_assign and out_always_comb
    xor_gate u_xor1(
       .a(a),
       .b(b),
       .out(out_assign)
    );
    
    xor_gate u_xor2(
       .a(a),
       .b(b),
       .out(out_always_comb)
    );
    
    // Implement the flip-flop logic directly for out_always_ff
    // and use a single always block for both combinational and sequential logic
    always @(posedge clk or a or b) begin
        if (a != b) begin
            out_always_ff <= 1'b1;
        end else begin
            out_always_ff <= 1'b0;
        end
    end
    
endmodule
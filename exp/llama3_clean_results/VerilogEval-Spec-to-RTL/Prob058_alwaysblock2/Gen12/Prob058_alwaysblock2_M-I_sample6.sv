// Define a separate module for the XOR gate
module xor_gate(
    input a,
    input b,
    output out
);
    
    assign out = a ^ b;
    
endmodule

// TopModule implementation with improvements
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
    assign out_always_comb = a ^ b;
    
    // Implement the flip-flop logic directly for out_always_ff with clock gating
    reg clock_enable; // Assuming a mechanism to generate clock_enable when input signals are changing
    always_ff @(posedge clk) begin
        if (clock_enable) begin
            out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
        end
    end
    
endmodule
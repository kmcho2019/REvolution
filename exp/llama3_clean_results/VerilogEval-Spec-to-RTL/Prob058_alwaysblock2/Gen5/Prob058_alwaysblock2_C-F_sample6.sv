// Define a module for the flip-flop
module xor_ff(
    input clk,
    input a,
    input b,
    output reg out
);
    
    always_ff @(posedge clk) begin
        out <= a ^ b; // Use non-blocking assignment to prevent race conditions
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
    
    // Assign statement for out_assign
    assign out_assign = a ^ b;
    
    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Instantiate the XOR gate and flip-flop for out_always_ff
    xor_ff u_ff(
      .clk(clk),
      .a(a),
      .b(b),
      .out(out_always_ff)
    );
    
endmodule
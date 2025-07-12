// Define a separate module for the XOR gate using assign
module xor_assign(
    input a,
    input b,
    output out_assign
);
    assign out_assign = a ^ b;
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
    
    // Instantiate the XOR gate module for out_assign
    xor_assign u_assign(
       .a(a),
       .b(b),
       .out_assign(out_assign)
    );
    
    // Directly implement the combinational logic for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Directly implement the flip-flop logic for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
    end
    
endmodule
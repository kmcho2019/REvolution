// Define a separate module for the XOR gate using clocked always block
module xor_always_ff(
    input clk,
    input a,
    input b,
    output reg out_always_ff
);
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
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
    
    // Directly implement the XOR gate using assign
    assign out_assign = a ^ b;
    
    // Directly implement the XOR gate using combinational always block
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Instantiate the XOR gate module for the clocked always block
    xor_always_ff u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out_always_ff(out_always_ff)
    );
    
endmodule
// Define a separate module for the XOR gate using assign
module xor_assign(
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

// Define a separate module for the XOR gate using clocked always block
module xor_always_ff(
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
    output reg out_always_ff
);
    
    // Instantiate the XOR gate module for out_assign
    xor_assign u_assign(
       .a(a),
       .b(b),
       .out(out_assign)
    );
    
    // Directly implement the combinational logic for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end
    
    // Instantiate the XOR gate module for out_always_ff
    xor_always_ff u_always_ff(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff)
    );
    
endmodule
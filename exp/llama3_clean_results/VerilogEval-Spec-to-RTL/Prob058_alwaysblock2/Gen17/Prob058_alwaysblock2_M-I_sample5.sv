// Define a separate module for the XOR gate using assign
module xor_assign(
    input a,
    input b,
    output out_assign
);
    assign out_assign = a ^ b;
endmodule

// Define a separate module for the XOR gate using combinational always block
module xor_always_comb(
    input a,
    input b,
    output reg out_always_comb
);
    always_comb begin
        out_always_comb = a ^ b;
    end
endmodule

// Define a separate module for the XOR gate using clocked always block
module xor_always_ff(
    input clk,
    input a,
    input b,
    output reg out_always_ff
);
    reg clk_enable;
    assign clk_enable = a != b; // Enable clock only when inputs change
    always_ff @(posedge clk) begin
        if (clk_enable) begin
            out_always_ff <= a ^ b; // Use non-blocking assignment to prevent race conditions
        end
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
    
    // Instantiate the XOR gate modules
    xor_assign u_assign(
        .a(a),
        .b(b),
        .out_assign(out_assign)
    );
    
    xor_always_comb u_always_comb(
        .a(a),
        .b(b),
        .out_always_comb(out_always_comb)
    );
    
    xor_always_ff u_always_ff(
        .clk(clk),
        .a(a),
        .b(b),
        .out_always_ff(out_always_ff)
    );
    
endmodule
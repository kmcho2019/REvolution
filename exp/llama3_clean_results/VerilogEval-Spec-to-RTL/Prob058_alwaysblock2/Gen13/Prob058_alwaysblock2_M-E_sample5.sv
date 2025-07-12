// Define a generic XOR gate module
module generic_xor(
    input clk,
    input [1:0] mode, // 2'b00: assign, 2'b01: combinational always block, 2'b10: clocked always block
    input a,
    input b,
    output reg out
);
    always @(*) begin
        if (mode == 2'b00) begin // Assign mode
            out = a ^ b;
        end else if (mode == 2'b01) begin // Combinational always block mode
            out = a ^ b;
        end
    end
    
    always_ff @(posedge clk) begin
        if (mode == 2'b10) begin // Clocked always block mode
            out <= a ^ b; // Use non-blocking assignment
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
    output out_always_ff
);
    
    // Instantiate the generic XOR gate modules
    generic_xor u_assign(
        .clk(clk),
        .mode(2'b00),
        .a(a),
        .b(b),
        .out(out_assign)
    );
    
    generic_xor u_always_comb(
        .clk(clk),
        .mode(2'b01),
        .a(a),
        .b(b),
        .out(out_always_comb)
    );
    
    generic_xor u_always_ff(
        .clk(clk),
        .mode(2'b10),
        .a(a),
        .b(b),
        .out(out_always_ff)
    );
    
endmodule
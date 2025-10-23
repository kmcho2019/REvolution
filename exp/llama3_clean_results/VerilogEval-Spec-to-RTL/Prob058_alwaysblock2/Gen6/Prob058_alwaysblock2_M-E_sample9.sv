// Define a module for the XOR pipeline stage
module XOR_Pipeline_Stage(
    input clk,
    input a,
    input b,
    input [1:0] mode, // 0: assign, 1: combinational always block, 2: clocked always block
    output reg out
);
    
    wire internal_xor;
    assign internal_xor = a ^ b;
    
    always @(posedge clk) begin
        if (mode == 0) begin // assign
            out <= internal_xor;
        end else if (mode == 1) begin // combinational always block
            out <= internal_xor;
        end else if (mode == 2) begin // clocked always block
            out <= internal_xor;
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
    
    // Instantiate the XOR pipeline stage for out_assign
    XOR_Pipeline_Stage u_stage1(
       .clk(clk),
       .a(a),
       .b(b),
       .mode(0),
       .out(out_assign)
    );
    
    // Instantiate the XOR pipeline stage for out_always_comb
    XOR_Pipeline_Stage u_stage2(
       .clk(clk),
       .a(a),
       .b(b),
       .mode(1),
       .out(out_always_comb)
    );
    
    // Instantiate the XOR pipeline stage for out_always_ff
    XOR_Pipeline_Stage u_stage3(
       .clk(clk),
       .a(a),
       .b(b),
       .mode(2),
       .out(out_always_ff)
    );
    
endmodule
// Define a separate module for the pipelined XOR gate
module pipelined_xor(
    input clk,
    input a,
    input b,
    output reg out
);
    
    reg stage1, stage2;
    
    always @(posedge clk) begin
        stage1 <= a ^ b;
        stage2 <= stage1;
        out <= stage2;
    end
    
endmodule

// Define a separate module for the latch-based XOR gate
module latch_xor(
    input a,
    input b,
    output out
);
    
    reg out_reg;
    
    always_latch begin
        if (a || b) begin
            out_reg = a ^ b;
        end else begin
            out_reg = 1'b0;
        end
    end
    
    assign out = out_reg;
    
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
    
    // Instantiate the XOR gate for out_assign
    assign out_assign = a ^ b;
    
    // Directly implement the combinational logic for out_always_comb
    assign out_always_comb = a ^ b;
    
    // Instantiate the pipelined XOR gate for out_always_ff
    pipelined_xor u_pipelined_xor(
       .clk(clk),
       .a(a),
       .b(b),
       .out(out_always_ff)
    );
    
    // Optional: Instantiate the latch-based XOR gate for comparison
    // latch_xor u_latch_xor(
    //    .a(a),
    //    .b(b),
    //    .out(out_always_ff)
    // );
    
endmodule
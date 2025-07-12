module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Single instance of XOR gate for area efficiency
    wire internal_xor;
    assign internal_xor = a ^ b;
    
    // Continuous assignment for out_assign
    assign out_assign = internal_xor;
    
    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = internal_xor;
    end
    
    // Clocked always block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= internal_xor;
    end

endmodule
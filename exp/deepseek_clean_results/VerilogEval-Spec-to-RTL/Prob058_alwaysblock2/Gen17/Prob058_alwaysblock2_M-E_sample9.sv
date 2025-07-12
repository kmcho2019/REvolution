module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // NAND-based XOR implementation for combinational paths
    wire a_nand_b = ~(a & b);
    wire a_xor_b = ~(a_nand_b & ~(a & ~b)) & ~(a_nand_b & ~(~a & b));

    assign out_assign = a_xor_b;
    
    always_comb begin
        // Same NAND-based XOR but in procedural form
        out_always_comb = ~(~(a & ~(a & b)) & ~(b & ~(a & b)));
    end

    // Clock-gated sequential logic
    reg enable;
    reg shadow_reg;
    
    always @(posedge clk) begin
        enable <= ~enable;  // Simple toggle for demonstration
    end

    always_ff @(posedge clk) begin
        if (enable) begin
            shadow_reg <= a ^ b;  // Store previous XOR result
        end
        out_always_ff <= shadow_reg;  // Output delayed by one cycle
    end

endmodule
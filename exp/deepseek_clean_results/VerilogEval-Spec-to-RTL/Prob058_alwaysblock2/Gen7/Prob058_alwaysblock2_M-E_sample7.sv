module CoreXOR (
    input a, b,
    output out
);
    assign out = a ^ b;
endmodule

module TopModule (
    input clk, a, b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    parameter ENABLE_FF = 1;  // Configurable sequential/comb mode
    
    // Input synchronization
    reg a_sync, b_sync;
    always @(posedge clk) begin
        a_sync <= a;
        b_sync <= b;
    end

    // Core XOR instances
    wire xor_result;
    CoreXOR xor_inst (.a(a_sync), .b(b_sync), .out(xor_result));
    
    // Output implementations
    assign out_assign = xor_result;
    
    reg out_comb;
    always @(*) out_comb = xor_result;
    assign out_always_comb = out_comb;
    
    // Conditional clock gating
    reg out_ff;
    wire clk_enable = (a_sync != a) || (b_sync != b);  // Only clock when inputs change
    wire gated_clk = clk & (ENABLE_FF ? clk_enable : 1'b0);
    
    always @(posedge gated_clk) begin
        out_ff <= xor_result;
    end
    assign out_always_ff = ENABLE_FF ? out_ff : xor_result;

endmodule
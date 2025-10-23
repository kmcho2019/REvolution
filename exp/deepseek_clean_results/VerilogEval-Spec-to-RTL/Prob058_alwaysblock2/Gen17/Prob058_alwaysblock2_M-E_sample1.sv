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
    parameter SKIP_FF = 0;  // Set to 1 to bypass flip-flop
    
    wire xor_result;
    reg a_sync, b_sync;
    reg out_ff;
    wire clk_enable = (a_sync != a) || (b_sync != b);  // Clock gating condition

    // Input synchronization
    always @(posedge clk) begin
        a_sync <= a;
        b_sync <= b;
    end

    // Core XOR logic instance
    CoreXOR xor_inst (
        .a(a_sync),
        .b(b_sync),
        .out(xor_result)
    );

    // Three output methods
    assign out_assign = xor_result;
    assign out_always_comb = xor_result;
    
    // Conditional sequential output
    generate
        if (SKIP_FF) begin
            assign out_always_ff = xor_result;
        end else begin
            always @(posedge clk) begin
                if (clk_enable)
                    out_ff <= xor_result;
            end
            assign out_always_ff = out_ff;
        end
    endgenerate

endmodule
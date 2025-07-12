module TopModule (
    input  clk,
    input  a,
    input  b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared intermediate signal
    wire xor_result = (a & ~b) | (~a & b);  // Alternative XOR expression
    
    // MUX-style assign implementation
    assign out_assign = a ? ~b : b;
    
    // Ternary operator for comb always
    always @(*) begin
        out_always_comb = a ? (b ? 1'b0 : 1'b1) : (b ? 1'b1 : 1'b0);
    end

    // Sequential logic with change detection
    reg a_prev, b_prev;
    wire inputs_changed = (a != a_prev) || (b != b_prev);
    
    always @(posedge clk) begin
        a_prev <= a;
        b_prev <= b;
        if (inputs_changed) begin
            out_always_ff <= xor_result;
        end
    end

endmodule
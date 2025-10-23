module XOR_Gate (
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Wire for input change detection
    wire inputs_changed;
    reg a_prev, b_prev;
    
    // Submodule instances
    XOR_Gate xor_assign (.a(a), .b(b), .out(out_assign));
    XOR_Gate xor_comb (.a(a), .b(b), .out(out_always_comb));
    
    // Input change detection
    assign inputs_changed = (a != a_prev) || (b != b_prev);
    
    always @(posedge clk) begin
        a_prev <= a;
        b_prev <= b;
        if (inputs_changed) begin
            out_always_ff <= a ^ b;
        end
    end

endmodule
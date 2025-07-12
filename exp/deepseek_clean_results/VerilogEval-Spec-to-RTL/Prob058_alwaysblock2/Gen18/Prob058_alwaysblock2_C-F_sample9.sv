module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Method 1: Direct continuous assignment (simplest and clearest)
    assign out_assign = a ^ b;

    // Method 2: Combinational always block (preferred SystemVerilog style)
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Method 3: Sequential implementation with optimized flip-flop
    reg last_a, last_b;
    wire xor_result = a ^ b;
    wire inputs_changed = (a != last_a) || (b != last_b);

    always @(posedge clk) begin
        last_a <= a;
        last_b <= b;
        
        // Only update when inputs change to save power
        if (inputs_changed) begin
            out_always_ff <= xor_result;
        end
    end

endmodule
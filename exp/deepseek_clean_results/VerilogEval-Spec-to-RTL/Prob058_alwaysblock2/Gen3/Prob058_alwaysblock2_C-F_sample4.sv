module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Method 1: Continuous assignment (wire output)
    assign out_assign = a ^ b;

    // Method 2: Combinational always block (reg output)
    always @(*) begin
        out_always_comb = a ^ b;
    end
    // Alternative: Could also use continuous assignment:
    // assign out_always_comb = a ^ b;

    // Method 3: Sequential always block (registered output)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
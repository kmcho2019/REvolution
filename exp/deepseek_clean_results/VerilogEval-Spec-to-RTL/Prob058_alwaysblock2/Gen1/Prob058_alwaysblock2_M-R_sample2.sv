module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment (unchanged)
    assign out_assign = a ^ b;

    // Option 1: Combinational always block with proper reg declaration
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Alternative Option 2: Could also use continuous assignment
    // assign out_always_comb = a ^ b;

    // Sequential always block (must be reg)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
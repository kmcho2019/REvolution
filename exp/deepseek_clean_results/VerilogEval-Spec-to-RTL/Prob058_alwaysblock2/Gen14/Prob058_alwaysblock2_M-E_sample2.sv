module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Method 1: Direct continuous assignment
    assign out_assign = a != b;  // Using inequality as XOR alternative

    // Method 2: Combinational always block with ternary operator
    always @(*) begin
        out_always_comb = a ? ~b : b;
    end

    // Method 3: Sequential implementation with pipeline and reset
    wire stage1_xor;
    assign stage1_xor = a ^ b;  // Pipeline stage 1: combinational XOR

    always @(posedge clk) begin
        // Pipeline stage 2: registered output
        out_always_ff <= stage1_xor;
    end

endmodule
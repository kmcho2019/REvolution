module TopModule (
    input clk,
    input a,
    input b,
    output wire out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared XOR computation
    wire current_xor = a ^ b;
    reg prev_xor;

    // Continuous assignment gets current XOR
    assign out_assign = current_xor;

    // Combinational always block gets current XOR
    always @(*) begin
        out_always_comb = current_xor;
    end

    // Pipeline the XOR result for sequential output
    always @(posedge clk) begin
        prev_xor <= current_xor;
        out_always_ff <= prev_xor;
    end

endmodule
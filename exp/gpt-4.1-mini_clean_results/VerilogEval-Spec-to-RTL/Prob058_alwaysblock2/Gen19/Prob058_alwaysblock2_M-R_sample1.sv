module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Combinational assign statement directly computing XOR
    assign out_assign = a ^ b;

    // Combinational always block with explicit sensitivity list
    always @(a or b) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block registering XOR result
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
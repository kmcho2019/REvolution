module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Combinational XOR using continuous assignment
    assign out_assign = a ^ b;

    // Combinational XOR using always block
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential XOR registered on clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
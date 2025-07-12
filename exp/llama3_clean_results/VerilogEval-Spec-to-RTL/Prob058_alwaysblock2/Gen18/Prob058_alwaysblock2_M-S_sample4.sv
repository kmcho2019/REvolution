module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    assign out_assign = a ^ b; // Implement XOR using assign statement

    always_comb begin
        out_always_comb = a ^ b; // Implement XOR using combinational always block
    end

    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b; // Implement XOR using clocked always block
    end

endmodule
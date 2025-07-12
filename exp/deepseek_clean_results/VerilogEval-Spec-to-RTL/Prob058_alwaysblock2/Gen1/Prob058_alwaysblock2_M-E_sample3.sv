module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment using basic gates instead of XOR operator
    assign out_assign = (a & ~b) | (~a & b);

    // Combinational always block with case statement
    always @(*) begin
        case ({a, b})
            2'b00: out_always_comb = 1'b0;
            2'b01: out_always_comb = 1'b1;
            2'b10: out_always_comb = 1'b1;
            2'b11: out_always_comb = 1'b0;
        endcase
    end

    // Sequential always block with intermediate register
    reg temp_ff;
    always @(posedge clk) begin
        temp_ff <= a ^ b;
        out_always_ff <= temp_ff;
    end

endmodule
module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

reg [1:0] shift_reg_seq;

// Continuous assignment: direct XOR
assign out_assign = a ^ b;

// Combinational always block with if-else for XOR
always @(*) begin
    if (a == b)
        out_always_comb = 1'b0;
    else
        out_always_comb = 1'b1;
end

// Sequential always block: 2-stage shift register delaying XOR
always @(posedge clk) begin
    shift_reg_seq[0] <= a ^ b;
    shift_reg_seq[1] <= shift_reg_seq[0];
    out_always_ff   <= shift_reg_seq[1];
end

endmodule
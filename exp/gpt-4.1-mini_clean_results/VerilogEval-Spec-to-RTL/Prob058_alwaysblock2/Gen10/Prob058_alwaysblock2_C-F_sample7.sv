module TopModule (
    input  clk,
    input  a,
    input  b,
    output      out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment for combinational XOR output
    assign out_assign = a ^ b;

    // Combinational always block for another combinational output with blocking assignment
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential always block for registered XOR output with non-blocking assignment
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
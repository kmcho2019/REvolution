module TopModule (
    input  clk,
    input  a,
    input  b,
    output      out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Intermediate wire for XOR of inputs a and b
    wire xor_ab = a ^ b;

    // Continuous assignment for combinational output out_assign
    assign out_assign = xor_ab;

    // Combinational always block for out_always_comb with blocking assignment
    always @(*) begin
        out_always_comb = xor_ab;
    end

    // Sequential always block for out_always_ff with nonblocking assignment
    always @(posedge clk) begin
        out_always_ff <= xor_ab;
    end

endmodule
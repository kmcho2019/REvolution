module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output reg  out_always_comb,
    output reg  out_always_ff
);

    // Continuous assignment with direct XOR operator
    assign out_assign = a ^ b;

    // Combinational always block computes XOR using concatenation and bitwise reduction
    always @(*) begin
        // Pack inputs into 2-bit vector and reduce XOR over bits
        out_always_comb = ^{a, b};
    end

    // Sequential always block implements a 1-bit shift register of XOR result
    reg xor_reg;
    always @(posedge clk) begin
        xor_reg <= a ^ b;
        out_always_ff <= xor_reg; // output delayed by one clock cycle
    end

endmodule
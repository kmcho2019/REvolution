module DFF (
    input  clk,
    input  d,
    output reg q
);
    // Simple D flip-flop with positive edge trigger
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output out_always_ff
);
    // Intermediate XOR result shared between implementations
    wire xor_result = a ^ b;

    // Method 1: Continuous assignment - simplest implementation
    assign out_assign = xor_result;

    // Method 2: Combinational logic - modern SystemVerilog style
    always_comb begin
        out_always_comb = xor_result;
    end

    // Method 3: Sequential logic using modular DFF
    DFF dff_inst (
        .clk(clk),
        .d(xor_result),
        .q(out_always_ff)
    );
endmodule
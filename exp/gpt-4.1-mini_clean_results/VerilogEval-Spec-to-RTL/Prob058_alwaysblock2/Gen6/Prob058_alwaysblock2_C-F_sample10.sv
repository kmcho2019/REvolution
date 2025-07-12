module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Shared internal wire for XOR computation to avoid redundant logic
    wire xor_val = a ^ b;

    // Continuous assignment output of XOR
    assign out_assign = xor_val;

    // Combinational always block: blocking assignment for combinational logic
    always @(*) begin
        out_always_comb = xor_val;
    end

    // Sequential always block: non-blocking assignment to register the XOR value
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule
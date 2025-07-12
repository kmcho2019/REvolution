module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment (most straightforward)
    assign out_assign = a ^ b;

    // Function for combinational logic
    function automatic logic xor_func(input logic x, y);
        return x ^ y;
    endfunction

    // Combinational always block using function
    always_comb begin
        out_always_comb = xor_func(a, b);
    end

    // Intermediate wire for sequential path
    wire comb_out = a ^ b;

    // Sequential always block
    always @(posedge clk) begin
        out_always_ff <= comb_out;
    end

endmodule
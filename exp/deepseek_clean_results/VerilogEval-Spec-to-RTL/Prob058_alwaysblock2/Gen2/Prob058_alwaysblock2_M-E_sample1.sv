module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment using ternary operator
    assign out_assign = a ? (b ? 1'b0 : 1'b1) : (b ? 1'b1 : 1'b0);

    // Function to calculate XOR
    function automatic logic calc_xor;
        input x, y;
        begin
            calc_xor = x ^ y;
        end
    endfunction

    // Combinational always block using function
    always @(*) begin
        out_always_comb = calc_xor(a, b);
    end

    // Clock divider for demonstration (updates every 2 cycles)
    reg clk_div;
    always @(posedge clk) begin
        clk_div <= ~clk_div;
    end

    // Sequential always block with clock divider
    always @(posedge clk_div) begin
        out_always_ff <= a ^ b;
    end

endmodule
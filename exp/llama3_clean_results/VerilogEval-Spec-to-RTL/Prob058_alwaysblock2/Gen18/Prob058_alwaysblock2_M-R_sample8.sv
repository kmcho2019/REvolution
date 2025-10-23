// TopModule implementation with local function for XOR calculation
module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Local function to calculate XOR
    function automatic logic xor_calc(input logic a, input logic b);
        xor_calc = a ^ b;
    endfunction

    // Assign statement for out_assign
    assign out_assign = xor_calc(a, b);

    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = xor_calc(a, b);
    end

    // Clocked always block for out_always_ff
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
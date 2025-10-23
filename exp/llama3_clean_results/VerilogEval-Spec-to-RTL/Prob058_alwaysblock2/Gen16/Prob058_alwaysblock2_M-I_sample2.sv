// Define a single module for the XOR gate with continuous assignment, combinational always block, and clocked always block
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);
    // Continuous assignment
    assign out_assign = a ^ b;

    // Combinational always block
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
endmodule
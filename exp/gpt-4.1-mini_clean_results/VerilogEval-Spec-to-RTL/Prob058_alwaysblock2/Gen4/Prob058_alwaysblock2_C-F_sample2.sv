module TopModule (
    input  clk,
    input  a,
    input  b,
    output       out_assign,
    output reg   out_always_comb,
    output reg   out_always_ff
);

    // Single XOR computation for reuse
    wire xor_val = a ^ b;

    // Continuous assignment for out_assign for minimal logic delay
    assign out_assign = xor_val;

    // Combinational always block for out_always_comb to clearly express combinational logic
    always_comb begin
        out_always_comb = xor_val;
    end

    // Sequential always block: register XOR result on rising clock edge for delayed output
    always @(posedge clk) begin
        out_always_ff <= xor_val;
    end

endmodule
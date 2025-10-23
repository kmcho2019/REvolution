module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff = 1'b0  // Initialize for simulation
);

    // Continuous assignment implementation
    assign out_assign = a ^ b;

    // Combinational always block implementation
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Sequential always block implementation
    always_ff @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule
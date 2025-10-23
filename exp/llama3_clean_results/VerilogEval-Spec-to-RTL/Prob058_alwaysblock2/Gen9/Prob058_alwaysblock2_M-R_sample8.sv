// TopModule implementing XOR gate in three ways
module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment for out_assign
    assign out_assign = a ^ b;

    // Combinational always block for out_always_comb
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Clocked always block with clock gating for out_always_ff
    always_ff @(posedge clk) begin
        if (1'b1) begin // Always enable the clock for this example
            out_always_ff <= a ^ b;
        end
    end

endmodule
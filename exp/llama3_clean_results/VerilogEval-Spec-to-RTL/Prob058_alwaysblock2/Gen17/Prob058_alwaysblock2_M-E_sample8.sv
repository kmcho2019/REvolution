module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output out_always_ff
);

    // Implement XOR gate using assign statement
    assign out_assign = a ^ b;

    // Implement XOR gate using combinational always block
    always_comb begin
        out_always_comb = a ^ b;
    end

    // Implement sequential XOR gate using clocked always block
    reg sequential_xor;
    always_ff @(posedge clk) begin
        sequential_xor <= a ^ b;
    end
    assign out_always_ff = sequential_xor;

    // Alternatively, implement XOR gate using multiplexers
    wire mux_out_a, mux_out_b;
    assign mux_out_a = a ? 1'b1 : 1'b0;
    assign mux_out_b = b ? 1'b1 : 1'b0;
    wire xor_mux_out;
    assign xor_mux_out = mux_out_a ^ mux_out_b;

endmodule
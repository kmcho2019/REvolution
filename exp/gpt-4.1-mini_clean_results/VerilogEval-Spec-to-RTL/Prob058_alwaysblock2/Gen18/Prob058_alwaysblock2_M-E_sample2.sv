module XorGate(
    input a,
    input b,
    output y
);
    assign y = a ^ b;
endmodule

module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);
    wire xor_wire;
    reg a_dly, b_dly;
    reg state;

    // Instantiate XOR gate for assign output
    XorGate xor_inst(.a(a), .b(b), .y(xor_wire));
    assign out_assign = xor_wire;

    // Register inputs to create delayed signals for combinational block
    always @(posedge clk) begin
        a_dly <= a;
        b_dly <= b;
    end

    // Combinational block uses registered inputs
    always @(*) begin
        out_always_comb = a_dly ^ b_dly;
    end

    // Simple FSM to implement XOR with state, toggling out_always_ff when XOR=1
    always @(posedge clk) begin
        if (xor_wire)
            state <= ~state;
        else
            state <= state;
        out_always_ff <= state;
    end

endmodule
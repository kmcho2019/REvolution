module TopModule #(
    parameter BIT_POS = 0
)(
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_reg;
    wire mux_out;
    wire feedback;

    // Generate appropriate feedback based on bit position
    assign feedback = (BIT_POS == 0) ? q_in :           // For q[0], feedback is direct
                     (BIT_POS == 1) ? q_in :           // For q[1], feedback is q[0]
                     (BIT_POS == 2) ? q_in : 1'b0;      // For q[2], feedback is q[1]^q[2]
                     // Note: Actual XOR will be handled in full_module's wiring

    // 2:1 MUX
    assign mux_out = L ? r_in : feedback;

    // D Flip-Flop
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

    assign Q = q_reg;

endmodule
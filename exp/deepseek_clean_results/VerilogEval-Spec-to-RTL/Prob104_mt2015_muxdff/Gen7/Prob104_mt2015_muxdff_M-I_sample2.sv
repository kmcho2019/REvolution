module TopModule (
    input clk,
    input L,
    input q_in,       // Feedback input
    input r_in,       // Load input
    output Q          // Output
);

    reg q_reg;

    // Continuous assignment for mux functionality
    wire mux_out = L ? r_in : q_in;

    // Edge-triggered flip-flop
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

    assign Q = q_reg;

endmodule
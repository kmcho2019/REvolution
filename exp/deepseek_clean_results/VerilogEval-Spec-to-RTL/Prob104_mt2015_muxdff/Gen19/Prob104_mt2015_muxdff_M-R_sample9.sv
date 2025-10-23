module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input
    input r_in,    // Parallel load input
    output Q
);

    wire mux_out;
    reg q_reg;

    // 2:1 mux - combinational logic
    assign mux_out = L ? r_in : q_in;

    // D Flip-Flop - sequential logic
    assign Q = q_reg;
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

endmodule
module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire mux_out;
    reg q_reg = 1'b0;  // Explicit initialization

    // 2:1 mux
    assign mux_out = L ? r_in : q_in;

    // Flip-flop with initialization
    assign Q = q_reg;
    always @(posedge clk) begin
        q_reg <= mux_out;
    end

endmodule
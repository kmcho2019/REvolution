module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire data_in;
    reg q_reg;

    // Tri-state implementation of 2:1 mux
    assign data_in = L ? r_in : 1'bz;
    assign data_in = ~L ? q_in : 1'bz;

    // D Flip-Flop with configurable input
    always @(posedge clk) begin
        q_reg <= data_in;
    end

    assign Q = q_reg;

endmodule
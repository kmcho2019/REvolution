module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    wire d_input;
    reg q_reg;

    // 2:1 Mux - combinational logic
    assign d_input = L ? r_in : q_in;

    // D Flip-flop - sequential logic
    always @(posedge clk) begin
        q_reg <= d_input;
    end

    // Output assignment
    assign Q = q_reg;

endmodule
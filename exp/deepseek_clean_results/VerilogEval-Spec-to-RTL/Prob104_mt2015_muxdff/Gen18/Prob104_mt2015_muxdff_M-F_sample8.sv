module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input
    input r_in,    // Parallel load input
    output Q
);

    reg q_reg;
    wire feedback_in;

    // Proper 2:1 mux implementation
    assign feedback_in = L ? r_in : q_in;

    // D Flip-Flop with configurable input
    always @(posedge clk) begin
        q_reg <= feedback_in;
    end

    assign Q = q_reg;

endmodule
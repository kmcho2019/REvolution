module TopModule (
    input clk,
    input L,
    input q_in,  // Feedback input from other bits
    input r_in,  // Load value input
    output Q     // Current bit output
);

    reg q_reg;

    always @(posedge clk) begin
        q_reg <= L ? r_in : q_in;
    end

    assign Q = q_reg;

endmodule
module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output Q
);

    reg q_reg;
    reg feedback_enable;

    always @(posedge clk) begin
        feedback_enable <= ~L;  // Enable feedback when not loading
        if (L) begin
            q_reg <= r_in;      // Load mode
        end else if (feedback_enable) begin
            q_reg <= q_in;      // Feedback mode
        end
    end

    assign Q = q_reg;

endmodule
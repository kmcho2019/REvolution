module TopModule (
    input clk,
    input L,
    input q_in,       // Feedback input
    input r_in,       // Load input
    output Q          // Output
);

    reg q_reg;

    always @(posedge clk) begin
        if (L) begin
            q_reg <= r_in;      // Load mode
        end else begin
            q_reg <= q_in;      // Operation mode (feedback)
        end
    end

    assign Q = q_reg;

endmodule
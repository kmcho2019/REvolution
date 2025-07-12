module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
    // input en // Optional enable signal (uncomment if needed)
);

reg feedback_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        feedback_reg <= 1'b0;
    end else begin
        // if (en) begin // Uncomment if using enable
            feedback_reg <= ~Q[0];
            Q <= {feedback_reg, Q[63:1]};
        // end
    end
end

endmodule
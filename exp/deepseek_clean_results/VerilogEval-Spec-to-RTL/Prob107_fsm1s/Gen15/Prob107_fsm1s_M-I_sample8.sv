module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State storage (0=B, 1=A)
    reg state;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // State B
            out <= 1'b1;
        end
        else begin
            state <= state ? in : ~in;
            out <= ~state;  // Registered output (1 for B, 0 for A)
        end
    end

endmodule
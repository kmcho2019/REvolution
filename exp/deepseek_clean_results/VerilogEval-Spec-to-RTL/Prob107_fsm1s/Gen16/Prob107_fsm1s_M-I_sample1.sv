module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

    // State storage
    reg state;
    wire next_state;

    // Next state logic (combinational)
    assign next_state = state ? in : ~in;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= 1'b0;  // State B
            out <= 1'b1;
        end
        else begin
            state <= next_state;
            // Registered output (reduces glitching)
            out <= ~next_state;  // out=1 when next_state is B (0)
        end
    end

endmodule
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definition: 0 = COPY, 1 = INVERT
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            // Efficient state transition
            state <= state | x;
            
            // Clear state-based output
            case (state)
                1'b0: z <= x;      // COPY state
                1'b1: z <= ~x;     // INVERT state
            endcase
        end
    end

endmodule
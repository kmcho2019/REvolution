module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Active-low reset
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment state
                if (wave == 5'b11111) begin  // Reached max value (31)
                    state <= 1'b1;           // Switch to decrement state
                end else begin
                    wave <= wave + 1'b1;     // Continue incrementing
                end
            end
            1'b1: begin  // Decrement state
                if (wave == 5'b00000) begin  // Reached min value (0)
                    state <= 1'b0;           // Switch to increment state
                end else begin
                    wave <= wave - 1'b1;     // Continue decrementing
                end
            end
        endcase
    end
end

endmodule
module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // 1-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0;
        wave <= 0;
    end else begin // Normal operation
        case (state)
            0: begin // Increment state
                wave <= wave + 1;
                if (wave == 31) begin // Transition to decrement state
                    state <= 1;
                end
            end
            1: begin // Decrement state
                wave <= wave - 1;
                if (wave == 0) begin // Transition back to increment state
                    state <= 0;
                end
            end
            default: ; // No action for other states
        endcase
    end
end

endmodule
module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment state
                wave <= wave + 1;
                if (wave == 5'b11111) state <= 1'b1;  // Max value reached
            end
            1'b1: begin  // Decrement state
                wave <= wave - 1;
                if (wave == 5'b00000) state <= 1'b0;  // Min value reached
            end
        endcase
    end
end

endmodule
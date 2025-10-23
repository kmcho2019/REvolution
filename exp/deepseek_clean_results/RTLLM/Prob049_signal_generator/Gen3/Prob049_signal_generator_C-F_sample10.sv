module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin  // Increment state
                wave <= (wave == 5'b11111) ? wave : wave + 1;
                state <= (wave == 5'b11111) ? 1'b1 : state;
            end
            1'b1: begin  // Decrement state
                wave <= (wave == 5'b00000) ? wave : wave - 1;
                state <= (wave == 5'b00000) ? 1'b0 : state;
            end
        endcase
    end
end

endmodule
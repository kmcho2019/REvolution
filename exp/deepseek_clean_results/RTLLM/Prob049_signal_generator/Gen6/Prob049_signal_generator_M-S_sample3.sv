module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b00000;
        state <= 0;
    end
    else begin
        case (state)
            0: begin  // Increment state
                if (wave == 5'b11111) begin  // Reached 31
                    state <= 1;
                    wave <= wave - 1;
                end
                else begin
                    wave <= wave + 1;
                end
            end
            1: begin  // Decrement state
                if (wave == 5'b00000) begin  // Reached 0
                    state <= 0;
                    wave <= wave + 1;
                end
                else begin
                    wave <= wave - 1;
                end
            end
        endcase
    end
end

endmodule
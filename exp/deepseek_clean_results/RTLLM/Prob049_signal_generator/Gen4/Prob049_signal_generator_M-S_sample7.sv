module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state; // 0=increment, 1=decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end
    else begin
        case (state)
            1'b0: begin
                wave <= wave + 1'b1;
                if (wave == 5'b11110) state <= 1'b1; // transition at 30->31
            end
            1'b1: begin
                wave <= wave - 1'b1;
                if (wave == 5'b00001) state <= 1'b0; // transition at 1->0
            end
        endcase
    end
end

endmodule
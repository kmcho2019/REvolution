module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0=increment, 1=decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        case (direction)
            1'b0: begin  // Incrementing
                if (wave == 5'b11111) begin
                    direction <= 1'b1;
                    wave <= wave - 1;
                end
                else begin
                    wave <= wave + 1;
                end
            end
            1'b1: begin  // Decrementing
                if (wave == 5'b00000) begin
                    direction <= 1'b0;
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
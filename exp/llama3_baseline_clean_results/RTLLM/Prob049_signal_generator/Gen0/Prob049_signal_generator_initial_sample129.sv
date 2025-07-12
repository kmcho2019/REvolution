module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // 1-bit state register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin // Incrementing state
                wave <= wave + 1;
                if (wave == 31) begin
                    state <= 1;
                end
            end
            1: begin // Decrementing state
                wave <= wave - 1;
                if (wave == 0) begin
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                wave <= 0;
            end
        endcase
    end
end

endmodule
module signal_generator (
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
            0: begin
                wave <= wave + 1;
                if (wave == 5'd31) begin // 5'd31 represents decimal 31 in 5-bit format
                    state <= 1;
                end
            end
            1: begin
                wave <= wave - 1;
                if (wave == 5'd0) begin // 5'd0 represents decimal 0 in 5-bit format
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
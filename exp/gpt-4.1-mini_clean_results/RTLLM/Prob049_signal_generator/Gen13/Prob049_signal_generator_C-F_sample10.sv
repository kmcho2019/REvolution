module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // increment mode
                    if (wave == 5'd31) begin
                        wave <= wave - 5'd1; // decrement immediately next cycle
                        state <= 1'b1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrement mode
                    if (wave == 5'd0) begin
                        wave <= wave + 5'd1; // increment immediately next cycle
                        state <= 1'b0;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    wave <= 5'd0;
                    state <= 1'b0;
                end
            endcase
        end
    end

endmodule
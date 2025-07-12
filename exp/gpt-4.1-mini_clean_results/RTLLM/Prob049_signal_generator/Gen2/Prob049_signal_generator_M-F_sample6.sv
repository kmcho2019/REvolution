module signal_generator (
    input  wire       clk,
    input  wire       rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: incrementing, 1: decrementing

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // incrementing
                    if (wave == 5'd31) begin
                        state <= 1'b1;
                        wave  <= wave - 5'd1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrementing
                    if (wave == 5'd0) begin
                        state <= 1'b0;
                        wave  <= wave + 5'd1;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    state <= 1'b0;
                    wave  <= 5'd0;
                end
            endcase
        end
    end

endmodule
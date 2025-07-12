module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // incrementing
                    if (wave == 5'd31) begin
                        // reached max, switch to decrement next cycle
                        wave <= 5'd30; // start decrementing immediately without holding at 31
                        state <= 1'b1;
                    end else begin
                        wave <= wave + 5'd1;
                        state <= 1'b0;
                    end
                end
                1'b1: begin // decrementing
                    if (wave == 5'd0) begin
                        // reached min, switch to increment next cycle
                        wave <= 5'd1; // start incrementing immediately without holding at 0
                        state <= 1'b0;
                    end else begin
                        wave <= wave - 5'd1;
                        state <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule
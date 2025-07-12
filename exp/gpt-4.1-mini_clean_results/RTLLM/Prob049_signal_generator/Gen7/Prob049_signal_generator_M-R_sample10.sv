module signal_generator (
    input        clk,
    input        rst_n,
    output reg [4:0] wave
);

    reg state; // 0: increment state, 1: decrement state

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // Increment state
                    if (wave == 5'd31) begin
                        state <= 1'b1; // Switch to decrement state
                        wave <= wave - 5'd1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // Decrement state
                    if (wave == 5'd0) begin
                        state <= 1'b0; // Switch to increment state
                        wave <= wave + 5'd1;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    state <= 1'b0;
                    wave <= 5'd0;
                end
            endcase
        end
    end

endmodule
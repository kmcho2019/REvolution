module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // Start incrementing
        end else begin
            case (state)
                1'b0: begin // Increment state
                    if (wave < 5'd31) begin
                        wave <= wave + 5'd1;
                    end else begin
                        // wave == 31, start decrementing next cycle
                        state <= 1'b1;
                        wave <= wave; // hold value to avoid unnecessary toggle
                    end
                end
                1'b1: begin // Decrement state
                    if (wave > 5'd0) begin
                        wave <= wave - 5'd1;
                    end else begin
                        // wave == 0, start incrementing next cycle
                        state <= 1'b0;
                        wave <= wave; // hold value to avoid unnecessary toggle
                    end
                end
            endcase
        end
    end

endmodule
module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    // Synchronous update with async reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;  // start by incrementing
        end else begin
            case (state)
                1'b0: begin // increment
                    if (wave == 5'd31) begin
                        state <= 1'b1;   // switch to decrement
                        wave  <= wave - 5'd1;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrement
                    if (wave == 5'd0) begin
                        state <= 1'b0;   // switch to increment
                        wave  <= wave + 5'd1;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
            endcase
        end
    end

endmodule
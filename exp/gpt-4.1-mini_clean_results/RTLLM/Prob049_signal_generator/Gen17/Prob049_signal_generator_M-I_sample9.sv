module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    // State: 0 = increment, 1 = decrement
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start incrementing
        end else begin
            case (state)
                1'b0: begin // increment mode
                    if (wave == 5'd31) begin
                        state <= 1'b1;  // switch to decrement
                        // hold wave at max
                        wave <= wave;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrement mode
                    if (wave == 5'd0) begin
                        state <= 1'b0;  // switch to increment
                        // hold wave at min
                        wave <= wave;
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
            endcase
        end
    end

endmodule
module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;       // Start incrementing
            wave  <= 5'd0;       // Initialize wave to 0
        end else begin
            case (state)
                1'b0: begin // Incrementing
                    if (wave == 5'd31) begin
                        state <= 1'b1;    // Switch to decrement state next cycle
                        wave  <= wave;    // Hold at 31 this cycle
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // Decrementing
                    if (wave == 5'd0) begin
                        state <= 1'b0;    // Switch to increment state next cycle
                        wave  <= wave;    // Hold at 0 this cycle
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    state <= 1'b0;       // Failsafe reset state
                    wave  <= 5'd0;       // Failsafe reset wave
                end
            endcase
        end
    end

endmodule
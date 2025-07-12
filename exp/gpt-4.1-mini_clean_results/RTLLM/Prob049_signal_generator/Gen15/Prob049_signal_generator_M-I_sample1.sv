module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            case (state)
                1'b0: begin // increment
                    if (wave == 5'd31) begin
                        state <= 1'b1;
                        wave  <= wave - 5'd1; // start decrementing immediately after reaching max
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrement
                    if (wave == 5'd0) begin
                        state <= 1'b0;
                        wave  <= wave + 5'd1; // start incrementing immediately after reaching 0
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
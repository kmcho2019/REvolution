module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset logic
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin // incrementing state
                wave <= wave + 1;
                if (wave == 5'd31) begin // transition to decrementing state
                    state <= 1;
                end
            end
            1: begin // decrementing state
                wave <= wave - 1;
                if (wave == 5'd0) begin // transition to incrementing state
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
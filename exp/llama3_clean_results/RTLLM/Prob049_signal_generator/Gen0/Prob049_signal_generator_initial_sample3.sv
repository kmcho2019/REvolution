module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin
                wave <= wave + 1;
                if (wave == 31) begin // transition to state 1 when wave reaches 31
                    state <= 1;
                end
            end
            1: begin
                wave <= wave - 1;
                if (wave == 0) begin // transition to state 0 when wave reaches 0
                    state <= 0;
                end
            end
            default: begin // default state
                state <= 0;
                wave <= 0;
            end
        endcase
    end
end

endmodule
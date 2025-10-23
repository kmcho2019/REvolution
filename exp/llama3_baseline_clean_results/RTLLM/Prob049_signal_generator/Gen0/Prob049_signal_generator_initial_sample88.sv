module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            2'd0: begin
                wave <= wave + 1;
                if (wave == 5'd31) begin
                    state <= 2'd1;
                end
            end
            2'd1: begin
                wave <= wave - 1;
                if (wave == 5'd0) begin
                    state <= 2'd0;
                end
            end
            default: begin
                state <= 2'd0;
                wave <= 5'd0;
            end
        endcase
    end
end

endmodule
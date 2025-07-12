module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] dir; // direction register (0: increment, 1: decrement)

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        dir <= 0;
        wave <= 0;
    end else begin
        if (dir == 0) begin // incrementing
            wave <= wave + 1;
            if (wave == 31) begin // transition to decrementing
                dir <= 1;
            end
        end else begin // decrementing
            wave <= wave - 1;
            if (wave == 0) begin // transition to incrementing
                dir <= 0;
            end
        end
    end
end

endmodule
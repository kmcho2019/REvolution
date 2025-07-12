module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg incrementing;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        wave <= 0;
        incrementing <= 1;
    end else begin
        if (incrementing) begin // incrementing
            wave <= wave + 1;
            if (wave == 31) begin // change direction when reaching maximum value
                incrementing <= 0;
            end
        end else begin // decrementing
            wave <= wave - 1;
            if (wave == 0) begin // change direction when reaching minimum value
                incrementing <= 1;
            end
        end
    end
end

endmodule
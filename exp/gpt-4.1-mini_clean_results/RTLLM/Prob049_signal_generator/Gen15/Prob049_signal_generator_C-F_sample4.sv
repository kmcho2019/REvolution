module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg direction; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave      <= 5'd0;
            direction <= 1'b0; // start incrementing
        end else begin
            // Update wave based on current direction with boundary saturation
            if (direction == 1'b0) begin
                if (wave < 5'd31)
                    wave <= wave + 5'd1;
                else
                    wave <= wave; // hold at max
            end else begin
                if (wave > 5'd0)
                    wave <= wave - 5'd1;
                else
                    wave <= wave; // hold at min
            end

            // Toggle direction at waveform boundaries
            if ((direction == 1'b0 && wave == 5'd31) ||
                (direction == 1'b1 && wave == 5'd0)) begin
                direction <= ~direction;
            end
        end
    end

endmodule
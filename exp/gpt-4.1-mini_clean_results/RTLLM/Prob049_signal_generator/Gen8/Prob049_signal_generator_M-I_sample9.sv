module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg signed [5:0] wave_next; // 6 bits to handle overflow for saturation
    reg signed [5:0] direction; // +1 or -1

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            direction <= 6'sd1; // start incrementing
        end else begin
            wave_next = wave + direction;

            // Saturate at boundaries, reverse direction if limit reached
            if (wave_next > 6'd31) begin
                direction <= -6'sd1;
                wave <= 5'd30; // step back from overflow
            end else if (wave_next < 6'd0) begin
                direction <= 6'sd1;
                wave <= 5'd1; // step forward from underflow
            end else begin
                wave <= wave_next[4:0];
            end
        end
    end

endmodule
module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg;
reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave_reg <= 0;
        direction <= 1; // initialize direction to increment
    end else begin
        if (direction == 1) begin // incrementing
            wave_reg <= (wave_reg == 31) ? 31 : wave_reg + 1;
            if (wave_reg == 31) begin
                direction <= 0; // switch to decrementing
            end
        end else begin // decrementing
            wave_reg <= (wave_reg == 0) ? 0 : wave_reg - 1;
            if (wave_reg == 0) begin
                direction <= 1; // switch to incrementing
            end
        end
    end
end

assign wave = wave_reg;

endmodule
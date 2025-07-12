module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg direction; // 0: incrementing, 1: decrementing
reg [4:0] lut[63:0]; // Look-Up Table for pre-computed waveform values

integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        direction <= 0;
        // Initialize LUT with ascending and descending values
        for (i = 0; i < 32; i++) begin
            lut[i] <= i;
            lut[i+32] <= 31 - i;
        end
    end else begin
        case (direction)
            0: begin
                counter <= (counter == 31) ? 0 : counter + 1;
                wave <= lut[counter];
                if (counter == 31) direction <= 1;
            end
            1: begin
                counter <= (counter == 63) ? 32 : counter + 1;
                wave <= lut[counter];
                if (counter == 63) direction <= 0;
            end
        endcase
    end
end

endmodule
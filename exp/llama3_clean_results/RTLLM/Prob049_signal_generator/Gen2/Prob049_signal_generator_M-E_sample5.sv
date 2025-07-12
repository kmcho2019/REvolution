module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 31; // maximum value of the waveform
parameter MIN_VALUE = 0; // minimum value of the waveform

reg [4:0] wave_value; // current waveform value
reg [4:0] counter; // counter to index the waveform LUT
reg direction; // direction of the counter (1 for increment, 0 for decrement)

// Lookup table to store the pre-computed waveform values
reg [4:0] waveform_lut [0:63]; // assuming a 64-entry LUT
initial begin
    for (int i = 0; i <= MAX_VALUE; i++) begin
        waveform_lut[i] = i;
    end
    for (int i = MAX_VALUE + 1; i < 64; i++) begin
        waveform_lut[i] = MAX_VALUE - (i - MAX_VALUE);
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        counter <= 0;
        direction <= 1; // initial direction is incrementing
    end else begin
        if (direction) begin // incrementing
            counter <= counter + 1;
            if (counter == MAX_VALUE + 1) begin // change direction when reaching maximum value
                direction <= 0;
            end
        end else begin // decrementing
            counter <= counter - 1;
            if (counter == 0) begin // change direction when reaching minimum value
                direction <= 1;
            end
        end
    end
end

assign wave = waveform_lut[counter];

endmodule
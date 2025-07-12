module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

parameter MAX_VALUE = 31; // maximum value of the waveform
parameter WAVEFORM_LENGTH = MAX_VALUE * 2 + 1; // length of the waveform

reg [4:0] waveform [WAVEFORM_LENGTH - 1:0]; // lookup table for waveform values
reg [9:0] count; // counter to index into the lookup table
reg direction; // direction of the counter (1 for increment, 0 for decrement)

// initialize lookup table with ascending and descending waveform values
integer i;
initial begin
    for (i = 0; i <= MAX_VALUE; i++) begin
        waveform[i] = i;
    end
    for (i = MAX_VALUE - 1; i >= 0; i--) begin
        waveform[MAX_VALUE + 1 + (MAX_VALUE - 1 - i)] = i;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // reset
        count <= 0;
        direction <= 1;
    end else begin
        if (direction) begin // incrementing
            if (count == MAX_VALUE) begin // change direction when reaching maximum value
                direction <= 0;
            end
            count <= count + 1;
        end else begin // decrementing
            if (count == 0) begin // change direction when reaching minimum value
                direction <= 1;
            end
            count <= count - 1;
        end
    end
end

assign wave = waveform[count];

endmodule
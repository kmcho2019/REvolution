module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter;
reg dir; // 1: increment, 0: decrement

// Lookup table to store the precomputed values of the waveform
reg [4:0] lut [31:0];

// Initialize the LUT with the precomputed values of the waveform
initial begin
    for (int i = 0; i <= 31; i++) begin
        if (i <= 15) begin
            lut[i] = i;
        end else begin
            lut[i] = 31 - i;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        dir <= 1;
    end else begin
        if (dir) begin
            if (counter == 31) begin
                counter <= 31;
                dir <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            if (counter == 0) begin
                counter <= 0;
                dir <= 1;
            end else begin
                counter <= counter - 1;
            end
        end
    end
end

assign wave = lut[counter];

endmodule
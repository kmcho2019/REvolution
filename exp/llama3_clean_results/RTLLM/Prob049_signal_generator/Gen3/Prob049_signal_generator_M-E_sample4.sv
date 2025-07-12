module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] counter; // 5-bit counter to generate the waveform
reg incr; // Flag to indicate whether to increment or decrement the counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        incr <= 1; // Start by incrementing
    end else begin
        if (incr) begin // Incrementing phase
            counter <= counter + 1;
            if (counter == 31) begin
                incr <= 0; // Switch to decrementing phase
            end
        end else begin // Decrementing phase
            counter <= counter - 1;
            if (counter == 0) begin
                incr <= 1; // Switch back to incrementing phase
            end
        end
    end
end

assign wave = counter; // Assign the counter value to the output waveform

endmodule
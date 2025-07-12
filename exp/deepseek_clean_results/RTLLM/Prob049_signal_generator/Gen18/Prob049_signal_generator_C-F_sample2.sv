module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter;  // 6-bit counter (5-bit value + 1-bit direction)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 6'b0;
    end
    else begin
        // Automatic direction change through natural overflow
        counter <= counter + (counter[5] ? -1 : 1);
    end
end

// Output only the lower 5 bits for clean 0-31 range
always @(*) begin
    wave = counter[4:0];
end

endmodule
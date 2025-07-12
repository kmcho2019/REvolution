module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter; // 6-bit counter for automatic direction control

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
    end else begin
        // Automatic direction change at boundaries
        counter <= counter + (counter[5] ? -1 : 1);
    end
end

// Convert counter to triangle wave (0-31 range)
always @(*) begin
    wave = counter[5] ? ~counter[4:0] : counter[4:0];
end

endmodule
module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // Counter to keep track of received bits

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        if (cnt < 3'b111) begin
            // Shift the bits into their final positions based on the counter value
            dout_parallel <= (dout_parallel << 1) | din_serial;
            cnt <= cnt + 1'b1;
        end else begin
            // When all 8 bits have been received, set dout_valid to 1
            dout_valid <= 1'b1;
        end
    end else begin
        // Reset the counter and output valid signal if din_valid is 0
        cnt <= 3'b000;
        dout_valid <= 1'b0;
    end
end

endmodule
module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt;  // 3-bit counter to count up to 8

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        dout_parallel <= 8'b00000000;  // Reset output
        dout_valid <= 1'b0;  // Reset output valid signal
    end else if (din_valid) begin
        if (cnt < 3'b111) begin  // If counter is less than 8
            // Shift in the new data
            dout_parallel <= {dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If counter is 8, reset counter and set output valid signal
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end
    end else begin
        // If input is not valid, reset output valid signal
        dout_valid <= 1'b0;
    end
end

endmodule
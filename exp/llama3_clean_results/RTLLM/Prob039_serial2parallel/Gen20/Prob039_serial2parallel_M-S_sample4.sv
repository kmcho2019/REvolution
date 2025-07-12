module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [2:0] cnt; // 3-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output when the reset signal is low
        cnt <= 3'b000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 3'b111) begin
            // Shift in the new data
            dout_parallel <= {dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter and set the output valid signal to 1
            cnt <= 3'b000;
            dout_valid <= 1'b1;
        end
        // Set the output valid signal to 0 if the counter is not 8
        if (cnt != 3'b111) begin
            dout_valid <= 1'b0;
        end
    end
end

endmodule
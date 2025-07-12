module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, output, and valid signal when the reset signal is low
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new data and increment the counter
        dout_parallel <= {dout_parallel[6:0], din_serial};
        cnt <= cnt + 1'b1;
        // Set the output valid signal based on the counter value
        dout_valid <= (cnt == 4'b1000) ? 1'b1 : 1'b0;
        // Reset the counter when it reaches its maximum value
        if (cnt == 4'b1000) begin
            cnt <= 4'b0000;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule
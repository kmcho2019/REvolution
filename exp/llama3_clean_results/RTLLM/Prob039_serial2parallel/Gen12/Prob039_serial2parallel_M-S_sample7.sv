module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, output, and valid signal
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // Shift in the new data
        dout_parallel <= {dout_parallel[6:0], din_serial};
        // Increment the counter
        cnt <= cnt + 1'b1;
        // Check if 8 bits have been received
        if (cnt == 4'b1000) begin
            // Reset the counter and set the output valid signal
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end else begin
            // Set the output valid signal to 0
            dout_valid <= 1'b0;
        end
    end else begin
        // If the input is not valid, do not update the counter or output
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'b0;
    end
end

endmodule
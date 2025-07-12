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
        // Reset the counter, output, and validity signal
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data using a more efficient shifting mechanism
            dout_parallel <= {dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter and set the output valid signal to 1
            cnt <= 4'b0000;
            dout_valid <= 1'b1;
        end
    end else if (!din_valid && cnt == 4'b1000) begin
        // If the input is not valid and the counter is 8, reset the output valid signal
        dout_valid <= 1'b0;
    end
end

endmodule
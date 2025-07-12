module serial2parallel (
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// 4-bit counter to keep track of the number of serial input data bits received
reg [3:0] cnt;

// Temporary register to hold the shifted value before assigning it to dout_parallel
reg [7:0] temp_dout_parallel;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, output, and validity signal
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        temp_dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data using a more efficient shifting mechanism
            temp_dout_parallel <= {temp_dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
            // Set dout_valid to 0 until a full byte is received
            dout_valid <= 1'b0;
        end else begin
            // If the counter is 8, reset the counter, update dout_parallel, and set the output valid signal to 1
            cnt <= 4'b0000;
            dout_parallel <= temp_dout_parallel;
            temp_dout_parallel <= 8'b00000000;
            dout_valid <= 1'b1;
        end
    end else begin
        // If the input is not valid, reset the output valid signal and do not update the counter or output
        dout_valid <= 1'b0;
    end
end

endmodule
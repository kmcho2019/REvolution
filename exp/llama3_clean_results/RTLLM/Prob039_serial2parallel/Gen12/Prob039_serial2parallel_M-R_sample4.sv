module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// 4-bit counter to keep track of the number of serial input data bits received
reg [3:0] cnt;

// Internal signal for the output
reg [7:0] internal_dout_parallel;

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output
        cnt <= 4'b0000;
        internal_dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end
end

// Main logic
always @(posedge clk) begin
    if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 4'b1000) begin
            // Shift in the new data
            internal_dout_parallel <= {internal_dout_parallel[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
        end else begin
            // If the counter is 8, reset the counter
            cnt <= 4'b0000;
        end
    end else if (cnt == 4'b1000) begin
        // If the counter is 8 and the input is not valid, set the output valid signal to 1
        dout_valid <= 1'b1;
    end else begin
        // If the counter is not 8, set the output valid signal to 0
        dout_valid <= 1'b0;
    end
end

// Assign output signals
assign dout_parallel = internal_dout_parallel;

endmodule
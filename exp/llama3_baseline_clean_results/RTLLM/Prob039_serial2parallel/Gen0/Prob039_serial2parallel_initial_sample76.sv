module serial2parallel(
    input clk,                // Clock signal
    input rst_n,              // Reset signal (active low)
    input din_serial,         // Serial input data
    input din_valid,          // Validity signal for input data
    output [7:0] dout_parallel, // Parallel output data
    output dout_valid         // Validity signal for the output data
);

reg [7:0] shift_reg;         // Shift register to accumulate serial input data
reg [3:0] cnt;               // 4-bit counter to track the number of serial input data bits received
reg dout_valid_reg;          // Register to store the validity signal for the output data

// Initialize output signals
assign dout_parallel = shift_reg;
assign dout_valid = dout_valid_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        cnt <= 4'd0;
        shift_reg <= 8'd0;
        dout_valid_reg <= 1'd0;
    end else if (din_valid) begin // If input data is valid
        shift_reg <= {shift_reg[6:0], din_serial}; // Shift in the new serial input data
        cnt <= cnt + 1;                            // Increment the counter
        if (cnt == 4'd8) begin                     // If all 8 bits have been received
            cnt <= 4'd0;                            // Reset the counter
            dout_valid_reg <= 1'd1;                // Set the output validity signal high
        end else begin
            dout_valid_reg <= 1'd0;                // Otherwise, keep the output validity signal low
        end
    end else begin
        cnt <= cnt;                               // If input data is not valid, do not increment the counter
        shift_reg <= shift_reg;                   // Do not shift in new data
        if (cnt == 4'd8) begin
            dout_valid_reg <= 1'd1;                // Keep the output validity signal high if all 8 bits have been received
        end else begin
            dout_valid_reg <= 1'd0;                // Keep the output validity signal low otherwise
        end
    end
end

always @ (posedge clk) begin
    if (cnt == 4'd0 && din_valid == 1'd0) begin
        dout_valid_reg <= 1'd0;                    // Reset the output validity signal when no valid data is being received and counter is zero
    end
end

endmodule
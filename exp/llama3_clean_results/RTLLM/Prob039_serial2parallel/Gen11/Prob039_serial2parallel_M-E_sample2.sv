module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

// 3-bit counter to keep track of the number of serial input data bits received
reg [2:0] cnt;

// Shift register to accumulate the serial input data
reg [7:0] shift_reg;

// Load signal to indicate when the parallel output data is valid
reg load_dout;

// Initialize the counter, shift register, and output on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter, shift register, and output
        cnt <= 3'b000;
        shift_reg <= 8'b00000000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
        load_dout <= 1'b0;
    end else if (din_valid) begin
        // If the counter is less than 8, shift in the new data and increment the counter
        if (cnt < 3'b1000) begin
            // Shift in the new data
            shift_reg <= {shift_reg[6:0], din_serial};
            // Increment the counter
            cnt <= cnt + 1'b1;
            // Set the load signal to 0
            load_dout <= 1'b0;
        end else begin
            // If the counter is 8, set the load signal to 1
            load_dout <= 1'b1;
            // Reset the counter
            cnt <= 3'b000;
        end
    end else begin
        // If the input is not valid, do not update the counter or shift register
        cnt <= cnt;
        shift_reg <= shift_reg;
        load_dout <= 1'b0;
    end
end

// Load the accumulated data into the dout_parallel register and set the dout_valid signal
always @(posedge clk) begin
    if (load_dout) begin
        dout_parallel <= shift_reg;
        dout_valid <= 1'b1;
    end else begin
        dout_valid <= 1'b0;
    end
end

endmodule
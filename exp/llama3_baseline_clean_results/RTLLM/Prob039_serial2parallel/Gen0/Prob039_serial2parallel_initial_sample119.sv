module serial2parallel (
    input             clk,        // Clock signal
    input             rst_n,      // Reset signal (active low)
    input             din_serial, // Serial input data
    input             din_valid,  // Validity signal for input data
    output reg [7:0]  dout_parallel, // Parallel output data (8 bits wide)
    output reg        dout_valid   // Validity signal for the output data
);

// Internal counter to keep track of the number of serial input bits received
reg [3:0] cnt;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the internal state
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin
        // Increment the counter when valid input data is received
        cnt <= cnt + 1'd1;
        
        // Shift the input data into the output register
        if (cnt == 4'd0) begin
            dout_parallel <= {din_serial, 7'd0};
        end else if (cnt > 4'd0 && cnt < 4'd8) begin
            dout_parallel <= {dout_parallel[6:0], din_serial};
        end
        
        // Set the output validity signal when 8 input bits have been received
        if (cnt == 4'd7) begin
            dout_valid <= 1'd1;
        end else begin
            dout_valid <= 1'd0;
        end
        
        // Reset the counter when the output has been generated
        if (cnt == 4'd7) begin
            cnt <= 4'd0;
        end
    end else begin
        // Do nothing when the input data is not valid
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        dout_valid <= 1'd0;
    end
end

endmodule
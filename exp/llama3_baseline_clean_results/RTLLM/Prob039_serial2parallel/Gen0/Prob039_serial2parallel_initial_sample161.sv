module serial2parallel(
    input clk,        // Clock signal
    input rst_n,      // Reset signal (active low)
    input din_serial, // Serial input data
    input din_valid,  // Validity signal for input data
    output reg [7:0] dout_parallel, // Parallel output data (8 bits wide)
    output reg dout_valid          // Validity signal for the output data
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 4'd0; // Reset counter
        dout_parallel <= 8'd0; // Reset output register
        dout_valid <= 1'd0; // Reset validity signal
    end else if (din_valid) begin // When input data is valid
        case (cnt)
            4'd0: dout_parallel[7] <= din_serial; // Shift MSB
            4'd1: dout_parallel[6] <= din_serial; // Shift bit 6
            4'd2: dout_parallel[5] <= din_serial; // Shift bit 5
            4'd3: dout_parallel[4] <= din_serial; // Shift bit 4
            4'd4: dout_parallel[3] <= din_serial; // Shift bit 3
            4'd5: dout_parallel[2] <= din_serial; // Shift bit 2
            4'd6: dout_parallel[1] <= din_serial; // Shift bit 1
            4'd7: dout_parallel[0] <= din_serial; // Shift LSB
        endcase
        cnt <= cnt + 1; // Increment counter
        if (cnt == 4'd7) begin // When all 8 bits have been received
            dout_valid <= 1'd1; // Set validity signal to 1
        end else begin
            dout_valid <= 1'd0; // Set validity signal to 0
        end
    end else if (cnt == 4'd7) begin // Reset counter when all 8 bits have been received
        cnt <= 4'd0; // Reset counter
    end
end

endmodule
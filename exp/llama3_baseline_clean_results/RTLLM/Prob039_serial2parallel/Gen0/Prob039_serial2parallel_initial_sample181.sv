module serial2parallel (
    input clk, 
    input rst_n, 
    input din_serial, 
    input din_valid, 
    output reg [7:0] dout_parallel, 
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to track the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 4'b0000; // Initialize the counter to 0
        dout_parallel <= 8'b00000000; // Initialize the output data to 0
        dout_valid <= 1'b0; // Initialize the output validity signal to 0
    end else if (din_valid) begin // If the input data is valid
        if (cnt == 4'b1000) begin // If 8 serial data bits have been received
            cnt <= 4'b0000; // Reset the counter
            dout_valid <= 1'b1; // Set the output validity signal to 1
        end else begin
            cnt <= cnt + 1'b1; // Increment the counter
            dout_valid <= 1'b0; // Reset the output validity signal to 0
        end

        // Update the output data based on the received serial input
        case (cnt)
            4'b0000: dout_parallel <= {din_serial, 7'b0000000}; // MSB
            4'b0001: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0010: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0011: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0100: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0101: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0110: dout_parallel <= {dout_parallel[7:1], din_serial}; 
            4'b0111: dout_parallel <= {dout_parallel[7:1], din_serial}; // LSB
            default: dout_parallel <= dout_parallel;
        endcase
    end else begin
        cnt <= cnt; // Keep the counter unchanged
        dout_parallel <= dout_parallel; // Keep the output data unchanged
        dout_valid <= 1'b0; // Reset the output validity signal to 0
    end
end

endmodule
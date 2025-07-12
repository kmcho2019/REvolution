module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset the circuit when rst_n is low
        cnt <= 4'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin // When input data is valid
        if (cnt == 4'd8) begin // If 8 bits have been received
            cnt <= 4'd0; // Reset the counter
            dout_valid <= 1'd1; // Set output valid signal to 1
        end else begin
            cnt <= cnt + 1; // Increment the counter
            dout_parallel <= {din_serial, dout_parallel[7:1]}; // Shift in the new serial data
            dout_valid <= 1'd0; // Output valid signal is 0 until 8 bits are received
        end
    end else begin // If input data is not valid
        cnt <= cnt; // Counter remains the same
        dout_parallel <= dout_parallel; // Output parallel data remains the same
        dout_valid <= 1'd0; // Output valid signal is 0
    end
end

endmodule
module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // 4-bit counter to keep track of the number of serial input data bits received
reg [7:0] temp_parallel; // Temporary register to store the incoming serial data

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset the circuit when rst_n is low
        cnt <= 4'd0;
        temp_parallel <= 8'd0;
        dout_parallel <= 8'd0;
        dout_valid <= 1'd0;
    end else if (din_valid) begin // When input data is valid
        if (cnt == 4'd7) begin // If 7 bits have been received
            temp_parallel <= {din_serial, temp_parallel[7:1]}; // Shift in the new serial data
            cnt <= 4'd8; // Set counter to 8
            dout_valid <= 1'd1; // Set output valid signal to 1
            dout_parallel <= temp_parallel; // Assign temp_parallel to dout_parallel
        end else begin
            temp_parallel <= {din_serial, temp_parallel[7:1]}; // Shift in the new serial data
            cnt <= cnt + 1; // Increment the counter
            dout_valid <= 1'd0; // Output valid signal is 0 until 8 bits are received
        end
    end else begin // If input data is not valid
        cnt <= cnt; // Counter remains the same
        temp_parallel <= temp_parallel; // temp_parallel remains the same
        dout_valid <= 1'd0; // Output valid signal is 0
    end
end

endmodule
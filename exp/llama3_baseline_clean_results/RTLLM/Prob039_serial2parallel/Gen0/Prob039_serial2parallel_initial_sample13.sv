module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt; // Counter to keep track of the number of serial input data bits received

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        cnt <= 4'd0; // Initialize counter to 0
        dout_parallel <= 8'd0; // Initialize output to 0
        dout_valid <= 1'b0; // Initialize output validity to 0
    end else if (din_valid) begin // If input data is valid
        if (cnt < 4'd8) begin // If less than 8 bits have been received
            dout_parallel <= {dout_parallel[6:0], din_serial}; // Shift current output left and add new input data
            cnt <= cnt + 1; // Increment counter
            if (cnt == 4'd8) begin // If 8 bits have been received
                dout_valid <= 1'b1; // Set output validity to 1
            end else begin
                dout_valid <= 1'b0; // Set output validity to 0
            end
        end else begin // If 8 bits have been received
            cnt <= 4'd0; // Reset counter to 0
            dout_valid <= 1'b0; // Set output validity to 0
        end
    end
end

endmodule
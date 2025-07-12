module serial2parallel(
    input clk,
    input rst_n,
    input din_serial,
    input din_valid,
    output reg [7:0] dout_parallel,
    output reg dout_valid
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        cnt <= 4'b0000;
        dout_parallel <= 8'b00000000;
        dout_valid <= 1'b0;
    end else if (din_valid) begin  // Valid input data
        cnt <= cnt + 1'b1;  // Increment counter
        dout_parallel <= {dout_parallel[6:0], din_serial};  // Shift bits and insert new bit
        if (cnt == 4'b1000) begin  // Check if 8 bits are received
            cnt <= 4'b0000;  // Reset counter
            dout_valid <= 1'b1;  // Set valid output high
        end else begin
            dout_valid <= 1'b0;  // Otherwise, output is not valid
        end
    end else begin  // Invalid input data or waiting for data
        cnt <= cnt;
        dout_parallel <= dout_parallel;
        if (cnt == 4'b0000) begin  // If no data has been received
            dout_valid <= 1'b0;  // Output is not valid
        end else begin
            dout_valid <= 1'b0;  // Output is not valid until 8 bits are received
        end
    end
end

endmodule
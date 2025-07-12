module parallel2serial(
    input clk,
    input rst_n,
    input [3:0] d,
    output reg valid_out,
    output reg dout
);

reg [1:0] cnt; // Counter to track the bit position
reg [3:0] data; // Register to hold the parallel input

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        valid_out <= 0;
        cnt <= 0;
        data <= 0;
    end else begin
        if (cnt == 3) begin // Last bit of the parallel input
            data <= d; // Update data register with new parallel input
            cnt <= 0; // Reset counter
            valid_out <= 1; // Set valid signal
        end else begin
            cnt <= cnt + 1; // Increment counter
            valid_out <= 0; // Reset valid signal
            // Shift data register one bit to the left, with MSB going to LSB
            data <= {data[2:0], data[3]};
        end
    end
end

always @(posedge clk) begin
    // Assign the most significant bit of data to dout
    dout <= data[3];
end

endmodule
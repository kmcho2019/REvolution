module parallel2serial (
    input  wire        clk,        // Clock signal
    input  wire        rst_n,      // Reset signal (active low)
    input  wire [3:0]  d,          // 4-bit parallel data input
    output wire        valid_out, // Valid signal indicating availability of serial output
    output wire        dout        // Serial output representing the converted data
);

reg [3:0] data; // Data register to hold the parallel input
reg [1:0] cnt;  // Counter to track the number of bits output
reg        valid; // Valid signal indicating availability of serial output

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module
        data <= 4'd0;
        cnt <= 2'd0;
        valid <= 1'b0;
    end else begin
        if (cnt == 2'd3) begin
            // Update the data register with the parallel input
            data <= d;
            // Reset the counter
            cnt <= 2'd0;
            // Set the valid signal to 1
            valid <= 1'b1;
        end else begin
            // Increment the counter
            cnt <= cnt + 1;
            // Set the valid signal to 0
            valid <= 1'b0;
            // Shift the data register one bit to the left
            data <= {data[2:0], 1'b0};
        end
    end
end

// Assign the most significant bit of the data register to the serial output
assign dout = data[3];

// Assign the valid signal to the output
assign valid_out = (cnt == 2'd0 && ~rst_n)? 1'b1 : 1'b0;

endmodule
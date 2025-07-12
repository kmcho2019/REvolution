module parallel2serial (
    input  clk,            // Clock signal
    input  rst_n,          // Reset signal (active low)
    input  [3:0] d,        // 4-bit parallel data input
    output valid_out,      // Valid signal indicating the availability of serial output
    output dout            // Serial output representing the converted data
);

reg [3:0] data;            // Data register
reg [1:0] cnt;             // Counter register
reg valid;                 // Valid signal

// Initialize the valid signal and counter
initial begin
    valid = 1'b0;
    cnt = 2'd0;
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the valid signal and counter
        valid <= 1'b0;
        cnt <= 2'd0;
        data <= 4'd0;
    end else begin
        // Check if the counter is at the last bit position
        if (cnt == 2'd3) begin
            // Update the data register with the parallel input
            data <= d;
            // Reset the counter
            cnt <= 2'd0;
            // Set the valid signal to 1
            valid <= 1'b1;
        end else begin
            // Increment the counter
            cnt <= cnt + 1'b1;
            // Set the valid signal to 0
            valid <= 1'b0;
            // Shift the data register one bit to the left
            data <= {data[2:0], 1'b0};
        end
    end
end

// Combinational logic
assign dout = data[3];
assign valid_out = (cnt == 2'd0) && valid;

endmodule
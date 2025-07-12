module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data;                  // Register to store the parallel input data
reg [1:0] cnt;                   // Counter to keep track of the bits

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data <= 4'b0000;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, reset counter and load parallel input data
            cnt <= 2'b00;
            data <= d;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
        end
    end
end

// Assign MSB of data register to serial output
assign dout = data[3];

// Shift data register one bit to the right on each clock cycle
always @ (posedge clk) begin
    if (cnt != 3) begin
        data <= {data[2:0], 1'b0};
    end
end

endmodule
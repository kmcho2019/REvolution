module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register

// Enable signal for data conversion
reg enable;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data <= 4'b0000;
        enable <= 1'b0;
    end else if (enable) begin
        // If conversion is enabled
        if (cnt == 3) begin
            // If counter has reached 3, reset counter and disable conversion
            cnt <= 2'b00;
            enable <= 1'b0;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
        end
    end else begin
        // If conversion is not enabled, check for new data
        if (d!= 4'b0000) begin
            // If new data is available, update data register and enable conversion
            data <= d;
            enable <= 1'b1;
            cnt <= 2'b00;
        end
    end
end

// Assign valid signal based on counter value and enable
assign valid_out = (enable && (cnt == 0))? 1 : 0;

// Assign most significant bit of data to output based on counter
assign dout = (enable)? data[3 - cnt] : 1'b0;

endmodule
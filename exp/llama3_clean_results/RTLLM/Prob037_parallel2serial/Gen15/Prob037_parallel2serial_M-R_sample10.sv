module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Register to hold the input data

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data <= 4'b0000;
        valid_out <= 1'b0;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, reset counter and load new data
            cnt <= 2'b00;
            data <= d;
            valid_out <= 1'b1;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
            valid_out <= 1'b0;
        end
    end
end

assign dout = data[3 - cnt];

endmodule
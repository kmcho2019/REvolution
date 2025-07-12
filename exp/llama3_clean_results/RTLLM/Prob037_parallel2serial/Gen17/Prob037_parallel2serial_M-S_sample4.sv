module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [3:0] data;                  // Register to hold the input data
reg [1:0] cnt;                   // Counter to keep track of the bits

assign valid_out = (cnt == 0) ? 1 : 0;  
assign dout = data[3];          

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 3) begin
        // If counter has reached 3, reset counter and update data register
        cnt <= 2'b00;
        data <= d;
    end else begin
        // Otherwise, increment counter and shift data register
        cnt <= cnt + 1;
        data <= {data[2:0], 1'b0};
    end
end

endmodule
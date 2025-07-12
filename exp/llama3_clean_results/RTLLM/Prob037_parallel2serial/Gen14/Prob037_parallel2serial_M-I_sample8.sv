module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // Counter to keep track of the bits
reg [3:0] data;                  // Data register to store the input data

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  

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
        // Otherwise, increment counter
        cnt <= cnt + 1;
    end
end

// Assign output dout based on counter value
always @ (*) begin
    case (cnt)
        2'b00: dout = data[3];
        2'b01: dout = data[2];
        2'b10: dout = data[1];
        2'b11: dout = data[0];
    endcase
end

endmodule
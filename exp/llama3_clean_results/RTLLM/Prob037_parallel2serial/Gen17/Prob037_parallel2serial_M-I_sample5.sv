module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [1:0] cnt;                   // 2-bit counter to keep track of the bits
reg [3:0] data;                  // 4-bit shift register to store parallel input data

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;

// Clock gating to minimize power consumption
wire clk_gated = (cnt != 0) ? clk : 1'b0;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and shift register
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 0) begin
        // Load parallel input data into shift register
        data <= d;
        cnt <= cnt + 1;
    end else if (cnt < 4) begin
        // Shift out data from shift register
        data <= {data[2:0], 1'b0};
        cnt <= cnt + 1;
    end else begin
        // Reset counter
        cnt <= 2'b00;
    end
end

// Assign serial output from shift register
assign dout = data[3];

endmodule
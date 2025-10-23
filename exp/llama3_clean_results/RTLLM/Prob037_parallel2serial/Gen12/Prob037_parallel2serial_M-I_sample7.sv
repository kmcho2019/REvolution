module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active high for synchronous reset)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data;                  // Data register

// Assign valid signal based on counter value
assign valid_out = (cnt == 2'b00);   

// Assign bit from input data based on counter
assign dout = data[3 - cnt];

// Sequential logic for counter and data
always @ (posedge clk) begin
    if (!rst_n) begin
        // Reset counter and data on reset
        cnt <= 2'b00;
        data <= 4'b0000;
    end else if (cnt == 2'b11) begin
        // If counter has reached 3, reset counter and update data
        cnt <= 2'b00;
        data <= d;
    end else begin
        // Otherwise, increment counter
        cnt <= cnt + 1'b1;
    end
end

endmodule
module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data_reg;              // Register to hold input data

assign valid_out = (cnt != 0);   // Assign valid signal based on counter value

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counter and data register
        cnt <= 2'b00;
        data_reg <= 4'b0000;
    end else begin
        if (cnt == 0) begin
            // Load input data into data register
            data_reg <= d;
            cnt <= 2'b01;
        end else if (cnt == 2'b11) begin
            // If counter has reached 3, reset counter
            cnt <= 2'b00;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1'b1;
        end
    end
end

assign dout = data_reg[3 - cnt]; // Assign bit from data register based on counter

endmodule
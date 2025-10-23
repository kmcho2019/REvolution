module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data_reg;              // Data register

assign valid_out = (cnt == 0);   // Assign valid signal based on counter value
assign dout = data_reg[3];       // Assign MSB of data register as output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 2'b00;
        data_reg <= 4'b0000;
    end else if (cnt == 2'b11) begin
        cnt <= 2'b00;
        data_reg <= d;
    end else begin
        cnt <= cnt + 1'b1;
        data_reg <= {data_reg[2:0], 1'b0}; // Shift data register to the left
    end
end

endmodule
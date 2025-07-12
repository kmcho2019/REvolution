module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output reg    dout           // Serial output representing the converted data
);

reg [1:0] cnt;                   // Internal counter
reg [3:0] data_reg;              // Internal data register
reg         valid;               // Internal valid signal

assign valid_out = (cnt == 2'b00);        // Assign internal valid signal to output

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers and signals
        cnt <= 2'b00;
        data_reg <= 4'b0000;
    end else begin
        if (cnt == 2'b11) begin
            // If counter has reached 3, update data register and reset counter
            data_reg <= d;
            cnt <= 2'b00;
        end else begin
            // Otherwise, increment counter
            cnt <= cnt + 1;
            // Shift data register one bit to the left, with the most significant bit shifted to the least significant bit
            data_reg <= {data_reg[2:0], data_reg[3]};
        end
    end
end

always @ (*) begin
    case (cnt)
        2'b00: dout = data_reg[3];  // Most significant bit
        2'b01: dout = data_reg[2];
        2'b10: dout = data_reg[1];
        2'b11: dout = data_reg[0];  // Least significant bit
        default: dout = 1'b0;
    endcase
end

endmodule
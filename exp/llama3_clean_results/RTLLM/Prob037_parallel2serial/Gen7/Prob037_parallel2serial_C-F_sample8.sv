module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data_reg;              // Data register to store the parallel input
reg [1:0] cnt;                   // Counter to keep track of the bits

// Assign valid signal based on counter value
assign valid_out = (cnt == 0) ? 1 : 0;  
// Assign most significant bit of data to output
assign dout = data_reg[3];          

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all internal registers
        data_reg <= 4'b0000;
        cnt <= 2'b00;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, update data register and reset counter
            data_reg <= d;
            cnt <= 2'b00;
        end else begin
            // Otherwise, increment counter and shift data register
            cnt <= cnt + 1;
            data_reg <= {data_reg[2:0], data_reg[3]};
        end
    end
end

endmodule
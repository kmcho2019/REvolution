module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data_reg;              // 4-bit shift register to store parallel input data
reg        valid_reg;             // Register to store valid signal

// Clock gating logic
wire       clk_gated;             // Gated clock signal

assign clk_gated = clk && valid_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset registers
        data_reg <= 4'b0000;
        valid_reg <= 1'b0;
    end else if (valid_reg == 1'b0) begin
        // Load parallel input data into shift register
        data_reg <= d;
        valid_reg <= 1'b1;
    end else begin
        // Shift shift register one bit to the right
        data_reg <= {data_reg[2:0], 1'b0};
        // Clear valid signal after 4 clock cycles
        if (data_reg == 4'b0000) begin
            valid_reg <= 1'b0;
        end
    end
end

// Assign most significant bit of shift register to serial output
assign dout = data_reg[3];

// Assign valid signal
assign valid_out = valid_reg;

endmodule
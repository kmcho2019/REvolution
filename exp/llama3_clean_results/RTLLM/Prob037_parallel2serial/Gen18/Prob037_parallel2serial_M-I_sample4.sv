module parallel2serial (
    input         clk,            // Clock signal
    input         rst_n,          // Reset signal (active low)
    input  [3:0]  d,              // 4-bit parallel data input
    output        valid_out,      // Valid signal indicating availability of serial output
    output        dout           // Serial output representing the converted data
);

// Internal registers
reg [3:0] data_reg;              // Register to store the parallel input data
reg [1:0] cnt;                   // Counter to keep track of the bits
reg        valid_out_reg;        // Register to store the valid signal

// Clock gating
reg        clk_gated;            // Gated clock signal

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset registers
        data_reg <= 4'b0000;
        cnt <= 2'b00;
        valid_out_reg <= 1'b0;
        clk_gated <= 1'b0;
    end else begin
        if (cnt == 3) begin
            // If counter has reached 3, reset counter and data register
            cnt <= 2'b00;
            data_reg <= d;
            valid_out_reg <= 1'b1;
            clk_gated <= 1'b1;
        end else if (clk_gated) begin
            // If clock is gated, increment counter and shift data register
            cnt <= cnt + 1;
            data_reg <= {data_reg[2:0], 1'b0};
            if (cnt == 3) begin
                clk_gated <= 1'b0;
            end
        end
    end
end

// Assign serial output based on data register
assign dout = data_reg[3];

// Assign valid signal
assign valid_out = valid_out_reg;

endmodule
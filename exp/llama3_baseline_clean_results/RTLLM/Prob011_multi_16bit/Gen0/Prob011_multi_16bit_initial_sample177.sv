module multi_16bit (
    input clk,            // Chip clock signal
    input rst_n,          // Active-low reset signal
    input start,          // Chip enable signal to initiate the multiplication operation
    input [15:0] ain,     // Input signal representing the multiplicand (a)
    input [15:0] bin,     // Input signal representing the multiplier (b)
    output [31:0] yout,   // Product output signal
    output done           // Chip output flag signal
);

reg [15:0] areg;          // Multiplicand register
reg [15:0] breg;          // Multiplier register
reg [31:0] yout_r;        // Product register
reg [4:0] i;              // Shift count register
reg done_r;               // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done_r <= 1'b0;
    end else begin
        // Normal operation
        if (start && (i < 16)) begin
            // Store multiplicand and multiplier in registers
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end
            // Shift and accumulate operation
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            // Increment shift count
            i <= i + 1;
        end else if (!start) begin
            // Reset shift count and registers
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end
        // Update multiplication completion flag
        if (i == 16) begin
            done_r <= 1'b1;
        end else if (i == 17) begin
            done_r <= 1'b0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
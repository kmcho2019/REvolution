module multi_16bit(
    input clk,         // Chip clock signal
    input rst_n,       // Active-low reset signal
    input start,       // Chip enable signal to initiate the multiplication operation
    input [15:0] ain,  // Input signal representing the multiplicand (a)
    input [15:0] bin,  // Input signal representing the multiplier (b)
    output [31:0] yout, // Product output signal
    output done         // Chip output flag signal
);

reg [4:0] i;           // Shift count register
reg [31:0] yout_r;     // Product register
reg [15:0] areg;       // Multiplicand register
reg [15:0] breg;       // Multiplier register
reg done_r;            // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        i <= 5'd0;
        done_r <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i < 5'd16) begin
            // Increment shift count register
            i <= i + 1;
        end else if (i == 5'd16) begin
            // Completion of multiplication operation
            done_r <= 1'b1;
            i <= i;
        end else if (i == 5'd17) begin
            // Reset multiplication completion flag
            done_r <= 1'b0;
            i <= 5'd0;
        end
    end else begin
        // Reset shift count register
        i <= 5'd0;
        done_r <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end else if (start) begin
        if (i == 5'd1) begin
            // Store multiplicand and multiplier in registers
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end else if (i > 5'd1 && i < 5'd17) begin
            // Shift and accumulate operation
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            areg <= areg >> 1;
        end
    end else begin
        // Reset multiplicand and multiplier registers
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
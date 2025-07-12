module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg; // Register for multiplicand
reg [15:0] breg; // Register for multiplier
reg [31:0] yout_r; // Register for product
reg [4:0] i; // Shift count register
reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset condition: Reset all registers and flags
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        // Normal operation
        if (start) begin
            // Start signal is active
            if (i == 0) begin
                // Store multiplicand and multiplier in registers
                areg <= ain;
                breg <= bin;
            end
            // Increment shift count register
            if (i < 16) begin
                i <= i + 1;
            end
            // Perform shift and accumulate operation
            if (i > 0 && i < 17) begin
                if (areg[i-1] == 1'b1) begin
                    // Accumulate shifted value of multiplier
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
        end else begin
            // Start signal is inactive: Reset shift count register
            i <= 0;
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
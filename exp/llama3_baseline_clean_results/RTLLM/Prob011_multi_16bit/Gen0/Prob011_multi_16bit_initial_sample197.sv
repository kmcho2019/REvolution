module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i; // Shift count register
reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [31:0] yout_r; // Product register
reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        i <= 5'b0;
        done_r <= 1'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
    end else if (start) begin // Start signal active
        if (i == 5'b0) begin // Initialize registers at i=0
            areg <= ain;
            breg <= bin;
            yout_r <= 32'b0;
        end else if (i < 5'b10000) begin // i < 16, perform shift and accumulate
            if (areg[i-1]) begin // Check bit at position i-1 in areg
                yout_r <= yout_r + (breg << (i-1)); // Accumulate shifted breg
            end
        end
        i <= i + 1; // Increment shift count
        if (i == 5'b10000) begin // Completion condition
            done_r <= 1'b1;
        end else begin
            done_r <= 1'b0;
        end
    end else begin // Start signal inactive, reset shift count and registers
        i <= 5'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        done_r <= 1'b0;
    end
end

always @(posedge clk) begin
    yout <= yout_r; // Output assignment
    done <= done_r; // Completion flag output
end

endmodule
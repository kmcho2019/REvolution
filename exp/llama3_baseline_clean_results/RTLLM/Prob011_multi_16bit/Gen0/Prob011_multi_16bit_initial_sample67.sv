module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] yout_r;
reg [4:0] i; // 5-bit register to count from 0 to 16
reg [15:0] areg, breg; // registers to hold the multiplicand and multiplier
reg done_r; // internal completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin
        if (i == 0) begin // Start of multiplication
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i < 17) begin // Shift and accumulate
            if (areg[i-1] == 1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        if (i == 16) begin // Completion of multiplication
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end
        i <= i + 1;
    end else begin // No multiplication in progress
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
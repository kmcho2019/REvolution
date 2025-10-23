module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [31:0] yout_r; // Product register
reg [4:0] i; // Shift count register
reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done_r <= 1'd0;
    end else if (start) begin
        // Start of multiplication operation
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
        end
        // Increment shift count register
        if (i < 5'd17) begin
            i <= i + 1'd1;
        end
        // Accumulate product
        if (i > 5'd0 && i < 5'd17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
    end else begin
        // Reset shift count register when start signal is inactive
        i <= 5'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        done_r <= 1'd0;
    end else if (i == 5'd16) begin
        // Set multiplication completion flag
        done_r <= 1'd1;
    end else if (i == 5'd17) begin
        // Reset multiplication completion flag
        done_r <= 1'd0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
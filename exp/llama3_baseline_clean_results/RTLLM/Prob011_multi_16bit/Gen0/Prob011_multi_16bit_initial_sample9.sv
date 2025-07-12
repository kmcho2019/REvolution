module multi_16bit (
    input clk,        // Chip clock signal
    input rst_n,      // Active-low reset signal
    input start,      // Chip enable signal
    input [15:0] ain, // Input signal representing the multiplicand (a)
    input [15:0] bin, // Input signal representing the multiplier (b)
    output [31:0] yout, // Product output signal
    output done       // Chip output flag signal
);

reg [15:0] areg;     // Register to store the multiplicand
reg [15:0] breg;     // Register to store the multiplier
reg [31:0] yout_r;   // Register to store the product
reg [4:0] i;         // Shift count register
reg done_r;         // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done_r <= 1'd0;
    end else if (start) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 32'd0;
        end else if (i < 5'd16) begin
            if (areg[15 - i]) begin
                yout_r <= yout_r + (breg << (i - 1));
            end
        end
        if (i < 5'd17) begin
            i <= i + 5'd1;
        end else begin
            i <= 5'd0;
        end
    end else begin
        i <= 5'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        done_r <= 1'd0;
    end else if (i == 5'd16) begin
        done_r <= 1'd1;
    end else if (i == 5'd17) begin
        done_r <= 1'd0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
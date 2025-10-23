module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg;  // Multiplicand register
reg [15:0] breg;  // Multiplier register
reg [31:0] yout_r;  // Product register
reg [4:0] i;  // Shift count register
reg done_r;  // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        i <= 5'd0;
        done_r <= 1'b0;
    end else if (start && i < 5'd17) begin
        if (i == 5'd0) begin
            areg <= ain;
            breg <= bin;
        end
        if (i > 5'd0 && i < 5'd17) begin
            if (areg[i-1] == 1'b1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        i <= i + 5'd1;
        if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end else if (!start) begin
        i <= 5'd0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
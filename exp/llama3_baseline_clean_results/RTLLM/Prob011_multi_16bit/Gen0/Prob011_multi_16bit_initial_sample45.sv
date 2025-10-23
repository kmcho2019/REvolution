module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i;  // Shift count register
reg [31:0] yout_r;  // Product register
reg [15:0] areg;  // Multiplicand register
reg [15:0] breg;  // Multiplier register
reg done_r;  // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        done_r <= 1'b0;
    end else begin
        if (start) begin
            if (i == 5'd16) begin
                done_r <= 1'b1;
                i <= i;
            end else if (i == 5'd17) begin
                done_r <= 1'b0;
                i <= 5'd0;
            end else begin
                if (i == 5'd0) begin
                    areg <= ain;
                    breg <= bin;
                end
                if (areg[i-1] == 1'b1 && i > 5'd0) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 5'd1;
            end
        end else begin
            i <= 5'd0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
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
reg [4:0] i;
reg [15:0] ain_r;
reg [15:0] bin_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        yout_r <= 0;
        done <= 0;
        ain_r <= 0;
        bin_r <= 0;
    end else begin
        if (start) begin
            if (i == 0) begin
                ain_r <= ain;
                bin_r <= bin;
            end
            if (i < 16) begin
                // Booth multiplier algorithm
                if (ain_r[15-i] == 1'b1) begin
                    yout_r <= yout_r + (bin_r << (15-i));
                end
                if (ain_r[15-i] == 1'b0 && ain_r[14-i] == 1'b1) begin
                    yout_r <= yout_r + (bin_r << (14-i));
                end
                i <= i + 1;
            end
            if (i == 16) begin
                done <= 1;
            end
        end else begin
            i <= 0;
            yout_r <= 0;
            done <= 0;
            ain_r <= 0;
            bin_r <= 0;
        end
    end
end

assign yout = yout_r;

endmodule
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
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        yout_r <= 0;
        areg <= 0;
        breg <= 0;
        done <= 0;
    end else begin
        if (start && i == 0) begin
            areg <= ain;
            breg <= bin;
        end
        if (start && i < 16) begin
            if (areg[i]) begin
                yout_r <= yout_r + (breg << i);
            end
            i <= i + 1;
        end
        if (i == 16) begin
            done <= 1;
        end
        if (!start || i >= 16) begin
            i <= 0;
            yout_r <= 0;
            areg <= 0;
            breg <= 0;
            done <= 0;
        end
    end
end

assign yout = yout_r;

endmodule
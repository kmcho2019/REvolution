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
reg [15:0] areg;
reg [15:0] breg;
reg [4:0] i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        yout_r <= 0;
        areg <= 0;
        breg <= 0;
        i <= 0;
        done <= 0;
    end else begin
        if (start && (i < 16)) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end
            if (areg[i-1] && (i > 0)) begin
                yout_r <= yout_r + (breg << (i-1));
            end
            i <= i + 1;
            if (i == 16) begin
                done <= 1;
            end else begin
                done <= 0;
            end
        end else if (!start) begin
            i <= 0;
            yout_r <= 0;
            areg <= 0;
            breg <= 0;
            done <= 0;
        end else if (i == 16) begin
            done <= 0;
            i <= 0;
        end
    end
end

always @(posedge clk) begin
    yout <= yout_r;
end

endmodule
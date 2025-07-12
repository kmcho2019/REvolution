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
reg done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 5'b0;
        done_r <= 1'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
    end else begin
        if (start) begin
            if (i < 5'd16) begin
                i <= i + 1'b1;
                if (i == 5'd1) begin
                    areg <= ain;
                    breg <= bin;
                end
                if (i > 5'd1 && areg[i-2] == 1'b1) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end else if (i == 5'd16) begin
                done_r <= 1'b1;
            end else if (i == 5'd17) begin
                done_r <= 1'b0;
                i <= 5'b0;
            end
        end else begin
            i <= 5'b0;
            done_r <= 1'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
        end
    end
end

always @(*) begin
    yout = yout_r;
    done = (i == 5'd16) ? 1'b1 : 1'b0;
end

endmodule
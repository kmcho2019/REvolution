module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg start_r;
reg [4:0] next_i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        done <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        start_r <= 0;
    end else begin
        start_r <= start;
        i <= next_i;
        
        if (start_r) begin
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
            end else if (i < 16) begin
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
        end
        
        if (i == 16) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

always @(*) begin
    if (~start_r) begin
        next_i <= 0;
    end else if (i < 16) begin
        next_i <= i + 1;
    end else begin
        next_i <= 0;
    end
end

assign yout = yout_r;

endmodule
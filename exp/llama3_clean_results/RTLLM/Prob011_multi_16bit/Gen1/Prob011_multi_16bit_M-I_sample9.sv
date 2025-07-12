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
reg start_r;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        done <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        start_r <= 0;
    end else begin
        if (start && !start_r) begin
            start_r <= 1;
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
            i <= 1;
        end else if (start_r) begin
            if (i < 16) begin
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
            end else begin
                start_r <= 0;
            end
        end else begin
            i <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
        end

        if (i == 16) begin
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

assign yout = yout_r;

endmodule
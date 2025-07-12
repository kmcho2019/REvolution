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
reg clock_enable;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 0;
        breg <= 0;
        i <= 0;
        yout_r <= 0;
        done <= 0;
        clock_enable <= 0;
    end else if (clock_enable) begin
        case (i)
            5'd0: begin
                areg <= ain;
                breg <= bin;
            end
            5'd1: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd2: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd3: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd4: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd5: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd6: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd7: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd8: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd9: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd10: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd11: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd12: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd13: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd14: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
            end
            5'd15: begin
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + breg;
                end
                areg <= areg >> 1;
                breg <= breg << 1;
                done <= 1;
            end
        endcase
        i <= i + 1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clock_enable <= 0;
    end else if (start) begin
        clock_enable <= 1;
    end else if (i == 16) begin
        clock_enable <= 0;
    end
end

assign yout = yout_r;

endmodule
module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

parameter Ain_WIDTH = 16;
parameter Bin_WIDTH = 16;
parameter Yout_WIDTH = 32;

reg [Ain_WIDTH-1:0] areg;
reg [Bin_WIDTH-1:0] breg;
reg [Yout_WIDTH-1:0] yout_r;
reg [3:0] state;
reg done_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        state <= 4'd0;
        done_r <= 1'b0;
    end else begin
        case (state)
            4'd0: begin // IDLE
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    state <= 4'd1;
                end
            end
            4'd1: begin // SHIFT AND ACCUMULATE
                if (areg[0] == 1'b1) begin
                    yout_r <= yout_r + {16'd0, breg};
                end
                areg <= areg >> 1;
                breg <= {breg[14:0], 1'b0};
                state <= 4'd2;
            end
            4'd2: begin // CHECK COMPLETION
                if (areg == 16'd0) begin
                    done_r <= 1'b1;
                    state <= 4'd3;
                end else begin
                    state <= 4'd1;
                end
            end
            4'd3: begin // DONE
                if (~start) begin
                    done_r <= 1'b0;
                    state <= 4'd0;
                end
            end
            default: begin
                state <= 4'd0;
            end
        endcase
    end
end

endmodule
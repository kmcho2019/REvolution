module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [1:0] state; // 0: idle, 1: multiplication, 2: done
reg [4:0] i;
reg [31:0] yout_r;
reg [15:0] areg;
reg [15:0] breg;
reg done_r;

assign yout = yout_r;
assign done = done_r;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 2'd0;
        i <= 5'd0;
        yout_r <= 32'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        done_r <= 1'b0;
    end else begin
        case (state)
            2'd0: begin // idle
                if (start) begin
                    state <= 2'd1;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    i <= 5'd0;
                end
            end
            2'd1: begin // multiplication
                if (i < 5'd16) begin
                    if (areg[i] == 1'b1) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1'b1;
                end else begin
                    state <= 2'd2;
                end
            end
            2'd2: begin // done
                done_r <= 1'b1;
                state <= 2'd0;
            end
        endcase
    end
end

endmodule
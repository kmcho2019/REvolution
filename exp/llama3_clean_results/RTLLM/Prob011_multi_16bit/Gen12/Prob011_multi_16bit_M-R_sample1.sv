module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i;
reg [31:0] yout_r;
reg done_r;
reg [2:0] state;
reg [15:0] areg;
reg [15:0] breg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;
        i <= 0;
        yout_r <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (start) begin
                    state <= 1;
                    areg <= ain;
                    breg <= bin;
                    i <= 0;
                    yout_r <= 0;
                end
            end
            1: begin // RUNNING
                if (i < 16) begin
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1;
                end else begin
                    state <= 2;
                end
            end
            2: begin // DONE
                done_r <= 1;
                state <= 0;
            end
        endcase
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
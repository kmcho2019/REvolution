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
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg done_r;
reg [1:0] state; // 0: Idle, 1: Start, 2: Multiply
reg clock_enable;

// State definitions
localparam IDLE = 2'd0;
localparam START = 2'd1;
localparam MULTIPLY = 2'd2;

always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
        clock_enable <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= START;
                    i <= 5'd0;
                    clock_enable <= 1'b1;
                end
            end
            START: begin
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                if (i < 5'd16) begin
                    if (areg[i] == 1'b1) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1'b1;
                end else begin
                    done_r <= 1'b1;
                    state <= IDLE;
                    clock_enable <= 1'b0;
                end
            end
        endcase
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule
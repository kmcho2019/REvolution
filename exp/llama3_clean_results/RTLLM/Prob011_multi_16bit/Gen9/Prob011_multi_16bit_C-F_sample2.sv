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
reg clock_enable;
reg [1:0] state; // 0: Idle, 1: Start, 2: Multiply

// State definitions
localparam IDLE = 2'd0;
localparam START = 2'd1;
localparam MULTIPLY = 2'd2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        i <= 0;
        yout_r <= 0;
        done <= 0;
        clock_enable <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= START;
                    clock_enable <= 1;
                end
            end
            START: begin
                yout_r <= 0;
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                if (i < 16) begin
                    if (ain[i] == 1'b1) begin
                        yout_r <= yout_r + (bin << i);
                    end
                    i <= i + 1;
                end else begin
                    done <= 1;
                    state <= IDLE;
                    clock_enable <= 0;
                end
            end
        endcase
    end
end

assign yout = yout_r;

endmodule
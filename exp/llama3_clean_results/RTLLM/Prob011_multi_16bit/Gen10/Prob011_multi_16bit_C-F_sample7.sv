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
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= START;
                end
            end
            START: begin
                yout_r <= 0;
                i <= 1;
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                if (i < 17) begin
                    if (ain[i-1] == 1'b1) begin
                        yout_r <= yout_r + (bin << (i-1));
                    end
                    i <= i + 1;
                end else begin
                    done <= 1;
                    state <= IDLE;
                end
            end
        endcase
    end
end

assign yout = yout_r;

endmodule
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
reg [4:0] i;
reg [31:0] yout_r;
reg done_r;

enum logic [2:0] {
    IDLE,
    INIT,
    MULTIPLY,
    DONE
} state, next_state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        areg <= 0;
        breg <= 0;
        i <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    i <= 1;
                end
            end
            INIT: begin
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
                if (i == 16) begin
                    done_r <= 1;
                end
            end
            MULTIPLY: begin
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
                if (i == 16) begin
                    done_r <= 1;
                end
            end
            DONE: begin
                done_r <= 0;
                i <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        IDLE: begin
            if (start) begin
                next_state = INIT;
            end else begin
                next_state = IDLE;
            end
        end
        INIT: begin
            if (i < 16) begin
                next_state = MULTIPLY;
            end else begin
                next_state = DONE;
            end
        end
        MULTIPLY: begin
            if (i < 16) begin
                next_state = MULTIPLY;
            end else begin
                next_state = DONE;
            end
        end
        DONE: begin
            next_state = IDLE;
        end
    endcase
end

assign yout = yout_r;
assign done = done_r;

endmodule
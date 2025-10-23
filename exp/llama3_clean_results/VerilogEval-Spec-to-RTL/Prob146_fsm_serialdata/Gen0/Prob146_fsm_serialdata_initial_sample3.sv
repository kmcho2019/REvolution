module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Define states
enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state, next_state;

// Define variables
logic [2:0] data_cnt;
logic [7:0] byte;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_cnt <= 3'b0;
        byte <= 8'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                byte[7] <= in;
                for (int i = 7; i > 0; i--) begin
                    byte[i-1] <= byte[i];
                end
                if (data_cnt == 7) begin
                    state <= STOP;
                end else begin
                    data_cnt <= data_cnt + 1;
                    state <= DATA;
                end
            end
            STOP: begin
                if (in) begin
                    state <= DONE;
                end else begin
                    state <= IDLE;
                end
            end
            DONE: begin
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
        if (state == DONE) begin
            out_byte <= byte;
            done <= 1'b1;
        end else begin
            done <= 1'b0;
        end
        if (state == START || state == IDLE) begin
            data_cnt <= 3'b0;
        end
    end
end

endmodule
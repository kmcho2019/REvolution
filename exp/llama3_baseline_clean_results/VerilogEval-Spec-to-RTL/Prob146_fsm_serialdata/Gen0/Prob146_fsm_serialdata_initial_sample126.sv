module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {IDLE, START, DATA, STOP, DONE} state;

logic [2:0] nextState;
logic [7:0] byte;
logic [2:0] bitCnt;

always_comb begin
    case(state)
        IDLE: begin
            if(in == 0) begin
                nextState = START;
            end else begin
                nextState = IDLE;
            end
        end
        START: begin
            nextState = DATA;
        end
        DATA: begin
            if(bitCnt == 7) begin
                nextState = STOP;
            end else begin
                nextState = DATA;
            end
        end
        STOP: begin
            if(in == 1) begin
                nextState = DONE;
            end else begin
                nextState = STOP;
            end
        end
        DONE: begin
            nextState = IDLE;
        end
        default: nextState = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        byte <= 8'b0;
        bitCnt <= 3'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                state <= nextState;
            end
            START: begin
                state <= nextState;
            end
            DATA: begin
                byte <= {byte[6:0], in};
                bitCnt <= bitCnt + 1;
                state <= nextState;
            end
            STOP: begin
                state <= nextState;
            end
            DONE: begin
                out_byte <= byte;
                done <= 1'b1;
                state <= nextState;
                byte <= 8'b0;
                bitCnt <= 3'b0;
            end
            default: state <= IDLE;
        endcase
    end
end

always_ff @(negedge clk) begin
    done <= 1'b0;
end

endmodule
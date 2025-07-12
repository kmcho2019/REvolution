module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states
enum logic [2:0] {
    IDLE,
    START,
    DATA,
    STOP,
    ERROR
} state, next_state;

// Bit position counter
reg [2:0] bit_pos;

// Synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        bit_pos <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            START: begin
                out_byte <= 8'b0;
                bit_pos <= 3'b0;
            end
            DATA: begin
                out_byte <= {out_byte[6:0], in};
                bit_pos <= bit_pos + 1'b1;
            end
            STOP: begin
                done <= 1'b1;
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

// Next state logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            next_state = DATA;
        end
        DATA: begin
            if (bit_pos == 3'b7) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            if (in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        ERROR: begin
            if (in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule
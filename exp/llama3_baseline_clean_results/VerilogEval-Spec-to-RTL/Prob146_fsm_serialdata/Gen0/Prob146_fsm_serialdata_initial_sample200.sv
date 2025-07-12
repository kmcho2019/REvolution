module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {IDLE, START, DATA, STOP} state, next_state;

logic [7:0] data_byte;
logic [2:0] bit_counter;

always_comb begin
    next_state = state;
    case (state)
        IDLE: if (!in) next_state = START;
        START: next_state = DATA;
        DATA: if (bit_counter == 8 - 1) next_state = STOP;
        STOP: if (in) next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_byte <= 8'b0;
        bit_counter <= 3'b0;
        out_byte <= 8'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            START: begin
                data_byte <= 8'b0;
                bit_counter <= 3'b0;
            end
            DATA: begin
                data_byte <= {data_byte[6:0], in};
                bit_counter <= bit_counter + 1'b1;
            end
            STOP: begin
                done <= 1'b1;
                out_byte <= data_byte;
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

endmodule
module TopModule(
    input           clk,
    input           in,
    input           reset,
    output [7:0]    out_byte,
    output          done
);

enum logic [2:0] {IDLE, START, DATA, STOP, ERROR} state, next_state;

logic [7:0] byte;
logic [2:0] bit_counter;

always_ff @(posedge clk) begin
    if (reset) begin
        state       <= IDLE;
        byte       <= 8'b0;
        bit_counter <= 3'b0;
    end else begin
        state       <= next_state;
        if (state == DATA || state == START) begin
            byte       <= {byte[6:0], in};
            bit_counter <= bit_counter + 1;
        end else if (state == STOP) begin
            byte       <= byte;
            bit_counter <= 3'b0;
        end else if (state == ERROR) begin
            byte       <= byte;
            bit_counter <= 3'b0;
        end else begin
            byte       <= byte;
            bit_counter <= 3'b0;
        end
    end
end

always_comb begin
    next_state = state;
    done       = 1'b0;

    case (state)
        IDLE: begin
            if (!in) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end

        START: begin
            next_state = DATA;
        end

        DATA: begin
            if (bit_counter == 3'b111) begin
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end

        STOP: begin
            if (in) begin
                next_state = IDLE;
                done       = 1'b1;
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

assign out_byte = (state == STOP) ? byte : 8'b0;

endmodule
module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT,
    DONE_STATE
} state, next_state;

logic [2:0] bit_counter;
logic [7:0] byte_register;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        bit_counter <= 3'b0;
        byte_register <= 8'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                out_byte <= 8'b0;
                done <= 1'b0;
            end
            DONE_STATE: begin
                out_byte <= byte_register;
                done <= 1'b1;
            end
            default: begin
                out_byte <= 8'b0;
                done <= 1'b0;
            end
        endcase
        case (state)
            DATA_BITS: begin
                byte_register <= {byte_register[6:0], in};
                bit_counter <= bit_counter + 1'b1;
            end
            default: begin
                bit_counter <= 3'b0;
            end
        endcase
    end
end

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (~in) begin
                next_state = START_BIT;
            end
        end
        START_BIT: begin
            next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (bit_counter == 8) begin
                next_state = STOP_BIT;
            end
        end
        STOP_BIT: begin
            if (in) begin
                next_state = DONE_STATE;
            end
        end
        DONE_STATE: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

// Enum for the states
enum logic [1:0] {IDLE, RECEIVE_DATA, VERIFY_STOP} state, next_state;

// Register to hold the received byte
logic [7:0] byte_reg;

// Counter to keep track of the number of bits received
logic [2:0] bit_counter;

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (!in) begin
                next_state = RECEIVE_DATA;
            end
        end
        RECEIVE_DATA: begin
            if (bit_counter == 7) begin
                next_state = VERIFY_STOP;
            end
        end
        VERIFY_STOP: begin
            if (in) begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        byte_reg <= 8'd0;
        bit_counter <= 3'd0;
        out_byte <= 8'd0;
        done <= 1'd0;
    end else begin
        case (state)
            IDLE: begin
                byte_reg <= 8'd0;
                bit_counter <= 3'd0;
                done <= 1'd0;
            end
            RECEIVE_DATA: begin
                byte_reg <= {byte_reg[6:0], in};
                bit_counter <= bit_counter + 1;
                done <= 1'd0;
            end
            VERIFY_STOP: begin
                out_byte <= byte_reg;
                if (in) begin
                    done <= 1'd1;
                end else begin
                    done <= 1'd0;
                end
            end
            default: begin
                byte_reg <= 8'd0;
                bit_counter <= 3'd0;
                done <= 1'd0;
            end
        endcase
        state <= next_state;
    end
end

endmodule
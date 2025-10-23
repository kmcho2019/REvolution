module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// Enum for states
enum logic [2:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT, DONE} state, next_state;

// Counter for data bits
logic [2:0] data_bit_count;

// Shift register for data bits
logic [7:0] data_bits;

// Assign next state and output
always_comb begin
    next_state = state;
    done = 1'b0;

    case(state)
        IDLE: begin
            if (~in) next_state = START_BIT;
        end
        START_BIT: begin
            next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (data_bit_count == 7) next_state = STOP_BIT;
        end
        STOP_BIT: begin
            if (in) next_state = DONE;
            else next_state = IDLE;
        end
        DONE: begin
            done = 1'b1;
            next_state = IDLE;
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_bit_count <= 0;
        data_bits <= 8'b0;
    end
    else begin
        state <= next_state;

        case(state)
            START_BIT: begin
                data_bits <= 8'b0;
                data_bit_count <= 0;
            end
            DATA_BITS: begin
                data_bits <= {data_bits[6:0], in};
                data_bit_count <= data_bit_count + 1;
            end
            DONE: begin
                out_byte <= {data_bits[6:0], in};
            end
        endcase
    end
end

endmodule
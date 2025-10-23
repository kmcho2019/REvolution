module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT
} state, next_state;

// Counter for data bits
logic [2:0] data_bit_counter;

// Register to store the received byte
logic [7:0] data;

always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (!in) next_state = START_BIT;
        end
        START_BIT: begin
            if (in) next_state = IDLE; // Invalid start bit, go back to idle
            else next_state = DATA_BITS;
        end
        DATA_BITS: begin
            if (data_bit_counter == 8'd7) next_state = STOP_BIT;
        end
        STOP_BIT: begin
            if (in) next_state = IDLE; // Invalid stop bit, go back to idle and wait for next stop bit
            else next_state = IDLE; // Valid stop bit, go back to idle
        end
        default: next_state = IDLE;
    endcase
end

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_bit_counter <= 3'd0;
        data <= 8'd0;
    end else begin
        state <= next_state;
        case (state)
            START_BIT: begin
                // Do nothing, just move to next state
            end
            DATA_BITS: begin
                data_bit_counter <= data_bit_counter + 1'd1;
                data <= {data[6:0], in}; // Shift in the new data bit
            end
            STOP_BIT: begin
                // Do nothing, just move to next state
            end
            default: begin
                data_bit_counter <= 3'd0;
                data <= 8'd0;
            end
        endcase
    end
end

// Assert done when a valid byte is received
assign done = (state == STOP_BIT && in);

endmodule
module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

// States for the FSM
enum logic [2:0] {
    IDLE,
    START_BIT,
    DATA_BITS,
    STOP_BIT_CHECK
} state, next_state;

// Register to hold the incoming byte
logic [7:0] data_reg;

// Counter for data bits
logic [2:0] data_bit_counter;

// Flag to indicate a valid byte is received
logic valid_byte;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        data_reg <= 8'b0;
        data_bit_counter <= 3'b0;
        valid_byte <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // Start bit detected
                    state <= START_BIT;
                    data_bit_counter <= 3'b0;
                end else begin
                    state <= IDLE;
                end
            end
            START_BIT: begin
                // Shift in the first data bit (LSB)
                data_reg[0] <= in;
                data_bit_counter <= data_bit_counter + 1'b1;
                state <= DATA_BITS;
            end
            DATA_BITS: begin
                if (data_bit_counter < 8) begin
                    // Shift in the next data bit
                    data_reg[data_bit_counter] <= in;
                    data_bit_counter <= data_bit_counter + 1'b1;
                    state <= DATA_BITS;
                end else begin
                    state <= STOP_BIT_CHECK;
                end
            end
            STOP_BIT_CHECK: begin
                if (in) begin // Stop bit is correct
                    valid_byte <= 1'b1;
                    state <= IDLE;
                end else begin // Incorrect stop bit, wait for a stop bit
                    state <= STOP_BIT_CHECK;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always_comb begin
    case (state)
        IDLE: next_state = IDLE;
        START_BIT: next_state = DATA_BITS;
        DATA_BITS: next_state = (data_bit_counter < 8)? DATA_BITS : STOP_BIT_CHECK;
        STOP_BIT_CHECK: next_state = (in)? IDLE : STOP_BIT_CHECK;
        default: next_state = IDLE;
    endcase
end

assign out_byte = data_reg;
assign done = (state == STOP_BIT_CHECK && in);

endmodule
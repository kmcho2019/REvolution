module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

    // Define the states
    enum logic [1:0] {
        IDLE,
        START,
        RECEIVE,
        STOP
    } state, next_state;

    // Counter for data bits
    logic [2:0] bit_counter;
    logic [2:0] next_bit_counter;

    // Data byte
    logic [7:0] byte;
    logic [7:0] next_byte;

    always_comb begin
        // Default values
        next_state = state;
        next_bit_counter = bit_counter;
        next_byte = byte;
        done = 0;

        case(state)
            IDLE: begin
                if (!in) begin
                    // Found start bit, move to START state
                    next_state = START;
                end
            end
            START: begin
                next_state = RECEIVE;
                next_bit_counter = 0;
            end
            RECEIVE: begin
                // Receive data bits
                next_byte = byte;
                next_byte[bit_counter] = in;
                next_bit_counter = bit_counter + 1;

                if (bit_counter == 7) begin
                    // All data bits received, move to STOP state
                    next_state = STOP;
                end
            end
            STOP: begin
                if (in) begin
                    // Stop bit verified, assert done and move to IDLE state
                    done = 1;
                    next_state = IDLE;
                end
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
            byte <= 0;
        end else begin
            state <= next_state;
            bit_counter <= next_bit_counter;
            byte <= next_byte;
        end
    end

    assign out_byte = byte;

endmodule
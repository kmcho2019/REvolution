module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// States for the FSM
enum logic [2:0] {
    IDLE,        // Waiting for start bit
    DATA_BITS,   // Receiving data bits
    STOP_BIT,    // Checking stop bit
    WAIT_STOP    // Waiting for stop bit after incorrect stop
} state, next_state;

// Counter for data bits
reg [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        bit_count <= 3'b0;
        done <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (!in) begin  // Start bit detected
                    next_state <= DATA_BITS;
                end else begin
                    next_state <= IDLE;
                end
            end
            DATA_BITS: begin
                if (bit_count == 8) begin
                    next_state <= STOP_BIT;
                end else begin
                    next_state <= DATA_BITS;
                    bit_count <= bit_count + 1;
                end
            end
            STOP_BIT: begin
                if (in) begin  // Correct stop bit
                    next_state <= IDLE;
                    done <= 1'b1;
                end else begin  // Incorrect stop bit
                    next_state <= WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in) begin  // Stop bit detected, can attempt next byte
                    next_state <= IDLE;
                end else begin
                    next_state <= WAIT_STOP;
                end
            end
            default: next_state <= IDLE;
        endcase
        case (state)
            IDLE, WAIT_STOP: bit_count <= 3'b0;
            DATA_BITS: ;
            STOP_BIT: begin
                done <= 1'b0;
                bit_count <= 3'b0;
            end
            default: ;
        endcase
    end
end

endmodule
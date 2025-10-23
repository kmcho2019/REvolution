module TopModule(
    input clk,
    input reset,
    input in,
    output reg done
);

// Define states
enum logic [1:0] {IDLE, RECEIVING, STOP_WAIT, DONE} state, nextState;

// Signals for managing start and stop bits
reg start_bit_detected;
reg stop_bit_verified;

// Counter for data bits
reg [2:0] data_bit_counter;

// Shift register for receiving data
reg [7:0] data_shift_reg;

// Combinatorial logic for next state and signal updates
always_comb begin
    // Default values
    nextState = state;
    start_bit_detected = 1'b0;
    stop_bit_verified = 1'b0;
    
    case(state)
        IDLE: begin
            if(in == 1'b0) begin
                start_bit_detected = 1'b1;
                nextState = RECEIVING;
            end
        end
        RECEIVING: begin
            if(data_bit_counter == 8) begin
                nextState = STOP_WAIT;
            end else begin
                nextState = RECEIVING;
            end
        end
        STOP_WAIT: begin
            if(in == 1'b1) begin
                stop_bit_verified = 1'b1;
                nextState = DONE;
            end else begin
                nextState = STOP_WAIT;
            end
        end
        DONE: begin
            nextState = IDLE;
        end
    endcase
end

// Sequential logic for state and signal updates
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        data_bit_counter <= 3'b0;
        data_shift_reg <= 8'b0;
        done <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                // Reset on idle
                data_bit_counter <= 3'b0;
                data_shift_reg <= 8'b0;
            end
            RECEIVING: begin
                // Shift data bit into register
                data_shift_reg <= {data_shift_reg[6:0], in};
                data_bit_counter <= data_bit_counter + 1;
            end
            STOP_WAIT: begin
                // Verify stop bit
                if(stop_bit_verified) begin
                    // Check start and stop bits
                    if(data_shift_reg[0] == 1'b0) begin // Note: Adjusted for least significant bit first
                        done <= 1'b1;
                    end else begin
                        done <= 1'b0;
                    end
                end
            end
            DONE: begin
                done <= 1'b0;
            end
        endcase
        state <= nextState;
    end
end

endmodule
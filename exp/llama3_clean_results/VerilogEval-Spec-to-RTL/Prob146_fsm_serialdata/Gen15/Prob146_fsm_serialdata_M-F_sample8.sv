module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

// Define states as parameters for better readability
parameter IDLE = 0, START = 1, DATA = 2, STOP = 3;

// Current state and next state registers
reg [1:0] state, next_state;

// Data register to hold the received byte
reg [7:0] data;

// Bit counter to track the number of bits received in the DATA state
reg [2:0] bit_counter, next_bit_counter;

// Synchronous reset for all registers
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all registers to their initial values
        state <= IDLE;
        data <= 8'b0;
        bit_counter <= 0;
        done <= 0;
        out_byte <= 8'b0;
    end
    else begin
        // Update state and bit counter on each clock cycle
        state <= next_state;
        bit_counter <= next_bit_counter;
        
        // When in the STOP state and a valid stop bit is received, assert done and update out_byte
        if (state == STOP && in) begin
            out_byte <= data;
            done <= 1;
        end
        else begin
            done <= 0;
        end
    end
end

// Combinational logic for next state and bit counter
always @(*) begin
    next_state = state;
    next_bit_counter = bit_counter;
    
    case(state)
        IDLE: begin
            // Wait for the start bit (0) to transition to the START state
            if (!in) begin
                next_state = START;
                next_bit_counter = 0;
            end
        end
        START: begin
            // If the start bit is not followed by a 0, return to IDLE
            if (in) begin
                next_state = IDLE;
            end
            else begin
                // Transition to the DATA state to receive the data bits
                next_state = DATA;
                next_bit_counter = 0;
            end
        end
        DATA: begin
            // Shift the data to the right and add the new bit at the MSB
            data = {in, data[7:1]};
            
            // Increment the bit counter
            next_bit_counter = bit_counter + 1;
            
            // After receiving 8 data bits, transition to the STOP state
            if (bit_counter == 3'd7) begin
                next_state = STOP;
            end
        end
        STOP: begin
            // If a valid stop bit (1) is received, return to IDLE
            if (in) begin
                next_state = IDLE;
                data <= 8'b0; // Reset data
                next_bit_counter = 0;
            end
            else begin
                // If not, stay in STOP until a valid stop bit is received
                next_state = STOP;
            end
        end
    endcase
end

endmodule
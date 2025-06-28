module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 2'b00,
          START_BIT = 2'b01,
          DATA_BITS = 2'b10,
          STOP_BIT = 2'b11;

// Registers
reg [1:0] state, next_state;

// Counter for data bits
reg [2:0] data_counter;

// State transition logic
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;  // Initial state
        data_counter <= 3'd0; // Reset data counter
        done <= 1'b0;  // Reset done signal
    end
    else begin
        state <= next_state;
        if (state == DATA_BITS && data_counter == 3'd7)
            data_counter <= 3'd0; // Reset data counter after receiving 8 data bits
        else if (state == DATA_BITS)
            data_counter <= data_counter + 1; // Increment data counter
    end
end

// Output logic
always @* begin
    done = 1'b0; // Default
    case(state)
        IDLE: begin
            if (in == 1'b0)
                next_state = START_BIT;
            else
                next_state = IDLE;
        end
        START_BIT: begin
            if (in == 1'b0)
                next_state = DATA_BITS;
            else
                next_state = IDLE;
        end
        DATA_BITS: begin
            if (data_counter == 3'd7 && in == 1'b1)
                next_state = STOP_BIT;
            else
                next_state = DATA_BITS;
        end
        STOP_BIT: begin
            if (in == 1'b1) begin
                done = 1'b1; // Byte received successfully
                next_state = IDLE;
            end
            else
                next_state = STOP_BIT;
        end
    endcase
end

endmodule
module TopModule (
  input clk,
  input in,
  input reset,
  output reg done
);

// Define states
parameter IDLE = 3'd0,
          START_BIT = 3'd1,
          DATA_BITS = 3'd2,
          STOP_BIT = 3'd3;

// Registers
reg [2:0] state, next_state;
reg [7:0] shift_reg;

// State transition logic
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;  // Initial state
        shift_reg <= 8'b0; // Clear shift register
        done <= 1'b0;  // Reset done signal
    end
    else begin
        state <= next_state;
    end
end

// Output logic
always @* begin
    done = 1'b0; // Default
    next_state = state; // Default next state
    case(state)
        IDLE: begin
            if (in == 1'b0)
                next_state = START_BIT;
            else
                next_state = IDLE;
        end
        START_BIT: begin
            shift_reg <= {shift_reg[6:0], in}; // Shift in the incoming bit
            if (shift_reg[0] == 1'b0)
                next_state = DATA_BITS;
            else
                next_state = IDLE;
        end
        DATA_BITS: begin
            shift_reg <= {shift_reg[6:0], in}; // Shift in the incoming bit
            if (shift_reg[7] == 1'b1)
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
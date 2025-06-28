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
reg [2:0] data_counter;

// FSM
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done <= 1'b0;
        data_counter <= 3'd0;
    end
    else begin
        state <= next_state;
    end
end

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
            // Increment data counter
            if (data_counter == 3'd7)
                next_state = STOP_BIT;
            else begin
                data_counter <= data_counter + 1;
                next_state = DATA_BITS;
            end
        end
        STOP_BIT: begin
            if (in == 1'b1) begin
                done = 1'b1; // Byte received successfully
                next_state = IDLE;
                data_counter <= 3'd0; // Reset data counter
            end
            else
                next_state = STOP_BIT;
        end
    endcase
end

endmodule
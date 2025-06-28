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
reg start_bit_detected;

// FSM
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data_counter <= 3'd0;
        start_bit_detected <= 1'b0;
        done <= 1'b0;
    end
    else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START_BIT;
                else
                    next_state = IDLE;
            end
            START_BIT: begin
                if (start_bit_detected) begin
                    if (data_counter < 3'd7)
                        next_state = DATA_BITS;
                    else
                        next_state = STOP_BIT;
                end
                else begin
                    if (in == 1'b0) begin
                        start_bit_detected <= 1'b1;
                        next_state = START_BIT;
                    end
                    else
                        next_state = IDLE;
                end
            end
            DATA_BITS: begin
                if (data_counter == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = DATA_BITS;
            end
            STOP_BIT: begin
                if (in == 1'b1)
                    done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end
end

// Increment data_counter when in the DATA_BITS state
always @* begin
    if (state == DATA_BITS)
        data_counter = data_counter + 1;
    else
        data_counter = 3'd0; // Reset counter
end

endmodule
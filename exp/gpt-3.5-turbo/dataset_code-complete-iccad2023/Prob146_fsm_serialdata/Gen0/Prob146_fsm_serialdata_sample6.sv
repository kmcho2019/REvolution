module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output reg done
);

// State Enum
typedef enum logic [1:0] {
  WAIT_FOR_START,
  RECEIVE_DATA,
  WAIT_FOR_STOP
} state_type;

// Registers
reg [2:0] state;
reg [7:0] rx_data_byte;
reg [2:0] bit_counter;

// Next State and Output Logic
always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= WAIT_FOR_START;
    rx_data_byte <= 8'b0;
    bit_counter <= 0;
    done <= 0;
  end
  else begin
    case(state)
      WAIT_FOR_START:
        if (in == 1'b0) begin
          state <= RECEIVE_DATA;
          bit_counter <= 0;
        end
        else begin
          state <= WAIT_FOR_START;
        end
      RECEIVE_DATA:
        if (bit_counter < 8) begin
          rx_data_byte[bit_counter] <= in;
          bit_counter <= bit_counter + 1;
          state <= RECEIVE_DATA;
        end
        else begin
          state <= WAIT_FOR_STOP;
          bit_counter <= 0;
        end
      WAIT_FOR_STOP:
        if (in == 1'b1) begin
          out_byte <= rx_data_byte;
          done <= 1;
          state <= WAIT_FOR_START;
        end
        else begin
          state <= WAIT_FOR_STOP;
        end
    endcase
  end
end

endmodule
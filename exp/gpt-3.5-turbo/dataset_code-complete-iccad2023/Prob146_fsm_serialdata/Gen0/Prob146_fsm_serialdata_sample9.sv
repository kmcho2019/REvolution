module TopModule (
  input clk,
  input in,
  input reset,
  output [7:0] out_byte,
  output done
);

// Define states
parameter IDLE = 2'b00;
parameter START_BIT = 2'b01;
parameter RECEIVE_BITS = 2'b10;
parameter STOP_BIT = 2'b11;

reg [1:0] state, next_state;
reg [7:0] data;
reg [2:0] bit_count;

// State transition and output logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    data <= 8'h00;
    bit_count <= 0;
    out_byte <= 8'h00;
    done <= 0;
  end
  else begin
    state <= next_state;
    case(state)
      IDLE: begin
        if (in == 1'b0) begin
          next_state = START_BIT;
          bit_count <= 0;
        end
        else begin
          next_state = IDLE;
        end
      end

      START_BIT: begin
        next_state = RECEIVE_BITS;
      end

      RECEIVE_BITS: begin
        if (bit_count < 8) begin
          data[bit_count] <= in;
          bit_count <= bit_count + 1;
          next_state = RECEIVE_BITS;
        end
        else begin
          next_state = STOP_BIT;
        end
      end

      STOP_BIT: begin
        if ((bit_count == 8) && (in == 1'b1)) begin
          out_byte <= data;
          done <= 1;
        end
        next_state = IDLE;
      end
    endcase
  end
end

endmodule
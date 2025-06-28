module TopModule (
  input clk,
  input in,
  input reset,
  output reg [7:0] out_byte,
  output reg done
);
  
typedef enum logic [1:0] {
  IDLE,
  START_BIT,
  DATA_BITS,
  STOP_BIT
} state_t;

reg [1:0] state, next_state;
reg [7:0] byte_buffer;

always_ff @(posedge clk or posedge reset)
begin
  if (reset)
  begin
    state <= IDLE;
    done <= 0;
    byte_buffer <= 8'b0;
    out_byte <= 8'b0;
  end
  else
    state <= next_state;
end

always_comb
begin
  next_state = IDLE;
  done = 0;
  out_byte = 8'b0;
  
  case(state)
    IDLE:
      if (in == 1) begin
        next_state = START_BIT;
      end
    START_BIT:
      begin
        byte_buffer <= 8'b0;
        next_state = DATA_BITS;
      end  
    DATA_BITS:
      begin
        byte_buffer <= {byte_buffer[6:0], in};
        if (state == 8) begin
          next_state = STOP_BIT;
        end
        else begin
          next_state = DATA_BITS;
        end
      end  
    STOP_BIT:
      begin
        if (in == 0) begin
          out_byte <= byte_buffer;
          done <= 1;
          next_state = IDLE;
        end
        else begin
          next_state = STOP_BIT;
        end
      end  
  endcase
end

endmodule
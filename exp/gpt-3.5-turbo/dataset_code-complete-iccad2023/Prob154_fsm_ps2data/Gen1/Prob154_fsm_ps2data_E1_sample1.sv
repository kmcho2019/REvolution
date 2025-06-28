module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define FSM states
parameter WAIT = 3'b000, RECEIVE_BYTE1 = 3'b001, RECEIVE_BYTE2 = 3'b010, RECEIVE_BYTE3 = 3'b011, OUTPUT_MESSAGE = 3'b100;
reg [2:0] state, next_state;
reg [7:0] byte1, byte2, byte3;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= WAIT;
    next_state <= WAIT;
    out_bytes <= 24'b0;
    done <= 0;
    byte1 <= 8'h00;
    byte2 <= 8'h00;
    byte3 <= 8'h00;
  end else begin
    state <= next_state;
    
    // Default next state to current state
    next_state <= state;

    case (state)
      WAIT: begin
        if (in[3] == 1) begin
          next_state = RECEIVE_BYTE1;
          byte1 <= in;
        end
      end
      RECEIVE_BYTE1: begin
        next_state = RECEIVE_BYTE2;
        byte2 <= in;
      end
      RECEIVE_BYTE2: begin
        next_state = RECEIVE_BYTE3;
        byte3 <= in;
      end
      RECEIVE_BYTE3: begin
        next_state = OUTPUT_MESSAGE;
      end
      OUTPUT_MESSAGE: begin
        out_bytes <= {byte1, byte2, byte3};
        done <= 1;
        next_state = WAIT;
      end
    endcase
  end
end

endmodule
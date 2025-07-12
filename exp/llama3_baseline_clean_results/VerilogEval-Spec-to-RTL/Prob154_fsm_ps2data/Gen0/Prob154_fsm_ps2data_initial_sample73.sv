module TopModule (
  input           clk,
  input           reset,
  input   [7:0]   in,
  output [23:0]   out_bytes,
  output          done
);

// Define the states of the FSM
typedef enum logic [1:0] {
  IDLE,
  RECEIVE_BYTE1,
  RECEIVE_BYTE2,
  DONE_RECEIVE
} state_t;

// Declare the current and next states
state_t current_state, next_state;

// Declare the register to hold the received bytes
reg [23:0] received_bytes;

// Combinational logic to determine the next state
always_comb begin
  case (current_state)
    IDLE: begin
      if (in[3]) begin
        next_state = RECEIVE_BYTE1;
      end else begin
        next_state = IDLE;
      end
    end
    RECEIVE_BYTE1: begin
      next_state = RECEIVE_BYTE2;
    end
    RECEIVE_BYTE2: begin
      next_state = DONE_RECEIVE;
    end
    DONE_RECEIVE: begin
      next_state = IDLE;
    end
    default: begin
      next_state = IDLE;
    end
  endcase
end

// Sequential logic to update the current state and received bytes
always_ff @(posedge clk) begin
  if (reset) begin
    current_state <= IDLE;
    received_bytes <= 24'h0;
  end else begin
    current_state <= next_state;
    case (current_state)
      IDLE: begin
        received_bytes <= 24'h0;
      end
      RECEIVE_BYTE1: begin
        received_bytes[23:16] <= in;
      end
      RECEIVE_BYTE2: begin
        received_bytes[15:8] <= in;
      end
      DONE_RECEIVE: begin
        received_bytes[7:0] <= in;
      end
    endcase
  end
end

// Output logic to generate the out_bytes and done signals
always_comb begin
  out_bytes = received_bytes;
  case (current_state)
    DONE_RECEIVE: begin
      done = 1'b1;
    end
    default: begin
      done = 1'b0;
    end
  endcase
end

endmodule
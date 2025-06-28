module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

// Define states
parameter FIRST_BYTE = 2'b01;
parameter SECOND_BYTE = 2'b10;
parameter THIRD_BYTE = 2'b11;

// Define signals
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= FIRST_BYTE;
  end else begin
    state <= next_state;
  end
end

// Combinational logic
always @(*) begin
  // Default next state
  next_state = state;

  case (state)
    FIRST_BYTE: begin
      if (in[3] == 1) begin
        next_state = SECOND_BYTE;
      end
    end

    SECOND_BYTE: begin
      if (in[3] == 1) begin
        next_state = THIRD_BYTE;
      end
    end

    THIRD_BYTE: begin
      next_state = FIRST_BYTE;
    end
  endcase
end

// Output logic
assign done = (state == THIRD_BYTE);

endmodule
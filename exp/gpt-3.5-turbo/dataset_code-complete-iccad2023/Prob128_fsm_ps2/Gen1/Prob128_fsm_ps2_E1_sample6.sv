module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output done
);

// Define states
parameter IDLE = 2'b00;
parameter SECOND_BYTE = 2'b01;
parameter THIRD_BYTE = 2'b10;
parameter DONE = 2'b11;

// Define signals
reg [1:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

// Combinational logic
always @(*) begin
  case (state)
    IDLE: begin
      if (in[3] == 1) begin
        next_state = SECOND_BYTE;
      end else begin
        next_state = IDLE;
      end
    end

    SECOND_BYTE: begin
      if (in[3] == 1) begin
        next_state = THIRD_BYTE;
      end else begin
        next_state = IDLE;
      end
    end

    THIRD_BYTE: begin
      if (in[3] == 1) begin
        next_state = DONE;
      end else begin
        next_state = IDLE;
      end
    end

    DONE: begin
      next_state = IDLE;
    end
  endcase
end

// Output logic
assign done = (state == DONE);

endmodule
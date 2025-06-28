module TopModule (
  input clk,
  input in,
  input reset,
  output done
);

// Define states
parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

// Define state register and next state logic
reg [1:0] state_reg, state_next;
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state_reg <= IDLE;
  end else begin
    state_reg <= state_next;
  end
end

// Define output
reg done_reg;
always @(posedge clk or posedge reset) begin
  if (reset) begin
    done_reg <= 1'b0;
  end else if (state_reg == STOP) begin
    done_reg <= 1'b1;
  end
end
assign done = done_reg;

// State transition and logic
always @(*) begin
  case (state_reg)
    IDLE: begin
      if (in == 1'b0 && $fell(in)) begin
        state_next = START;
      end else begin
        state_next = IDLE;
      end
    end
    START: begin
      state_next = DATA;
    end
    DATA: begin
      state_next = (state_next == 8) ? STOP : DATA + 1;
    end
    STOP: begin
      if (in == 1'b1 && $rose(in)) begin
        state_next = IDLE;
      end else begin
        state_next = STOP;
      end
    end
  endcase
end

endmodule
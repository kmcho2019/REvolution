module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

// Define states for the state machine
parameter IDLE = 2'b00;
parameter DETECTING_START = 2'b01;
parameter DETECTING_FINISH = 2'b10;

reg [1:0] state = IDLE;
reg [3:0] shift_reg = 4'b0;

always @(posedge clk, posedge reset) begin
  if (reset) begin
    start_shifting <= 0;
    state <= IDLE;
    shift_reg <= 4'b0;
  end
  else begin
    case (state)
      IDLE: begin
        if (data == 1'b1 && shift_reg == 4'b0) begin
          state <= DETECTING_START; // Detected possible start of sequence
          shift_reg <= {shift_reg[2:0], data};
        end
      end
      DETECTING_START: begin
        shift_reg <= {shift_reg[2:0], data};
        if (shift_reg == 4'b110) begin
          state <= DETECTING_FINISH; // Detected start of sequence
        end
      end
      DETECTING_FINISH: begin
        shift_reg <= {shift_reg[2:0], data};
        if (shift_reg == 4'b1101) begin
          start_shifting <= 1; // Complete sequence found, set shifting flag
        end
        else if (shift_reg != 4'b1101) begin
          state <= DETECTING_START; // Sequence interrupted, go back to start detection
          start_shifting <= 0;
        end
      end
    endcase
  end
end

endmodule
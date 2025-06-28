module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // Define states
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State register
  reg state, next_state;

  // Moore state machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
    end
    else begin
      state <= next_state;
    end
  end

  // Next state and output logic
  always @* begin
    case(state)
      OFF: begin
        if (j) begin
          next_state = ON;
        end 
        else begin
          next_state = OFF;
        end
        out = 1'b0;
      end
      ON: begin
        if (k) begin
          next_state = OFF;
        end 
        else begin
          next_state = ON;
        end
        out = 1'b1;
      end
    endcase
  end

endmodule
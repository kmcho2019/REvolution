module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output out
);

  // State encoding
  parameter OFF = 1'b0;
  parameter ON = 1'b1;

  // State registers
  reg current_state, next_state;

  // State transition logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= OFF;
    end else begin
      current_state <= next_state;
    end

    case (current_state)
      OFF:
        begin
          if (j)
            next_state = ON;
          else
            next_state = OFF;
        end
      ON:
        begin
          if (k)
            next_state = OFF;
          else
            next_state = ON;
        end
    endcase
  end

  // Output logic
  always @(current_state) begin
    case (current_state)
      OFF: out = 1'b0;
      ON: out = 1'b1;
    endcase
  end

endmodule
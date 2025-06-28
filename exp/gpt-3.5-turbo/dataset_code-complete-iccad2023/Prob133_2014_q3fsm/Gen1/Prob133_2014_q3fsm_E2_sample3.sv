module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  reg [1:0] state, next_state;
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter COUNTING = 2'b10;

  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end
  
  // Next state logic
  always @(*) begin
    case (state)
      A: begin
        if (s == 1) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if (w == 1) begin
          next_state = COUNTING;
        end else begin
          next_state = B;
        end
      end
      COUNTING: begin
        if (w == 1 && state != COUNTING) begin
          next_state = COUNTING;
        end else begin
          next_state = B;
        end
      end
      default: next_state = A;
    endcase
  end
  
  // Output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      z <= 0;
    end else begin
      if (state == COUNTING && $countones(w) == 2) begin
        z <= 1;
      end else begin
        z <= 0;
      end
    end
  end

endmodule
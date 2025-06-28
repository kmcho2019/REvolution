module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  reg [1:0] state, next_state;
  parameter A = 2'b00, B = 2'b01;
  
  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end
  
  // Next state logic
  always @* begin
    case(state)
      A: begin
        if (s == 1) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if ((w == 1) && (w == #1 0) && (w == #2 1)) begin
          z <= 1;
        end else begin
          z <= 0;
        end
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

endmodule
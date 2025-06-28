module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  parameter A = 2'b00;
  parameter B = 2'b01;
  
  // State register
  reg [1:0] state, next_state;
  
  // Count of 'w' being 1 within a 3-clock cycle window
  reg [2:0] w_count;
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 3'b0;
      z <= 0;
    end else begin
      state <= next_state;
      case(state)
        A: begin
             next_state = (s == 1) ? B : A;
           end
        B: begin
             w_count <= (w == 1) ? w_count + 1 : w_count;
             if (w_count == 3) begin
               z <= (w_count == 2) ? 1 : 0;
               w_count <= 0;
             end
             next_state = B;
           end
        default: next_state = A;
      endcase
    end
  end
endmodule
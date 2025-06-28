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
  
  // State and count registers
  reg [1:0] state, next_state;
  reg [2:0] w_count;
  
  // State transition and count logic
  always @(posedge clk or posedge reset) begin
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
             if (w == 1) begin
               w_count <= w_count + 1;
             end
             if (w_count == 3) begin
               z <= (w_count == 2) ? 1 : 0;
               w_count <= 0;
               next_state = A;
             end else begin
               next_state = B;
             end
           end
        default: next_state = A;
      endcase
    end
  end

endmodule
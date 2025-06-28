module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  parameter A = 1'b0;
  parameter B = 1'b1;
  
  // State register
  reg state, next_state;
  
  // Counter for consecutive 'w=1'
  reg [1:0] w_count;
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_count <= 2'b0;
      z <= 1'b0;
    end else begin
      state <= next_state;
      case(state)
        A: begin
             if (s == 1) begin
               next_state = B;
             end else begin
               next_state = A;
             end
           end
        B: begin
             if (w == 1) begin
               w_count <= w_count + 1;
             end else begin
               w_count <= 2'b0;
             end
             
             if (w_count == 2) begin
               z <= 1;
             end else begin
               z <= 0;
             end
             
             next_state = A; // Transition back to state A after output computation
           end
        default: next_state = A;
      endcase
    end
  end
endmodule
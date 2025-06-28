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
  
  // Count of 'w' being 1
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
             if (s == 1) begin
               next_state = B;
             end else begin
               next_state = A;
             end
           end
        B: begin
             if (w == 1) begin
               w_count <= w_count + 1;
             end
             if (w_count == 3) begin
               if (w_count == 2) begin
                 z <= 1;
               end else begin
                 z <= 0;
               end
               w_count <= 0;
             end
             next_state = B;
           end
      endcase
    end
  end
endmodule
module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  parameter B = 1'b1;
  
  // State and count registers
  reg state, w_count;
  
  // State transition and output logic
  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      w_count <= 0;
      z <= 0;
    end else begin
      case(state)
        0: begin
             if (s == 1) begin
               state <= B;
             end else begin
               state <= 0;
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
             state <= B;
           end
        default: state <= 0;
      endcase
    end
  end
endmodule
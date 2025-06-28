module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);
  
  // Define states
  reg [1:0] state;
  parameter B = 2'b01;
  
  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= B;
    end else begin
      state <= state;
    end
  end
  
  // Hard-coded state B logic
  always @(posedge clk) begin
    case (state)
      B: begin
        static int w_count = 0;
        static int cycle_count = 0;
        
        if (cycle_count == 3) begin
          if (w_count == 2) begin
            z <= 1;
          end else begin
            z <= 0;
          end
          w_count <= 0;
          cycle_count <= 0;
        end else begin
          if (w == 1) begin
            w_count <= w_count + 1;
          end
          cycle_count <= cycle_count + 1;
        end
      end
      default: z <= 0;
    endcase
  end
endmodule
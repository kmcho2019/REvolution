module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // Define states
  reg [1:0] state;
  parameter CHECK_W = 2'b00;
  
  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= CHECK_W;
      z <= 0;
    end else begin
      case(state)
        CHECK_W: begin
          if (w == 1) begin
            state <= CHECK_W;
          end else begin
            state <= CHECK_W;
          end
          
          // Count number of 'w' being 1 in 3-clock cycle window
          if (w == 1 && $past(w) == 0) begin
            state <= CHECK_W;
          end else if (w == 1 && $past(w) == 1) begin
            z <= 1;
            state <= CHECK_W;
          end else begin
            state <= CHECK_W;
          end
        end
        default: state <= CHECK_W;
      endcase
    end
  end
endmodule
module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // State definitions
  localparam A = 1'b0;
  localparam B = 1'b1;
  
  reg state, next_state;
  reg [2:0] w_history;
  reg [1:0] cycle_count;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      w_history <= 3'b0;
      cycle_count <= 2'b0;
      z <= 1'b0;
    end
    else begin
      state <= next_state;
      
      case (state)
        A: begin
          w_history <= 3'b0;
          cycle_count <= 2'b0;
          z <= 1'b0;
        end
        
        B: begin
          // Shift in current w value
          w_history <= {w_history[1:0], w};
          
          // Increment cycle counter
          if (cycle_count == 2'd2) begin
            cycle_count <= 2'd0;
            // Check if exactly two 1's in last 3 cycles
            case (w_history)
              3'b011, 3'b101, 3'b110: z <= 1'b1;
              default: z <= 1'b0;
            endcase
          end
          else begin
            cycle_count <= cycle_count + 1;
            z <= 1'b0;
          end
        end
      endcase
    end
  end
  
  // Next state logic
  always @(*) begin
    case (state)
      A: next_state = s ? B : A;
      B: next_state = B; // Stay in B once entered
      default: next_state = A;
    endcase
  end

endmodule
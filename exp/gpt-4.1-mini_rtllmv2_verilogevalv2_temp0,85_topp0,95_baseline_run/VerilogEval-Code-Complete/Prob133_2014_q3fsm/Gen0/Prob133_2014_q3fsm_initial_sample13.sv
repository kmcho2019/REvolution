module TopModule (
  input clk,
  input reset,
  input s,
  input w,
  output reg z
);

  // State encoding
  typedef enum logic [0:0] {A=1'b0, B=1'b1} state_t;
  state_t state, next_state;

  // Counters for cycles and w count in state B
  reg [1:0] cycle_count; // counts 0,1,2 cycles
  reg [1:0] w_count;     // counts how many times w=1 in current 3-cycle window

  // Synchronous state and counters update
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      cycle_count <= 0;
      w_count <= 0;
      z <= 0;
    end else begin
      state <= next_state;
      
      if (state == A) begin
        cycle_count <= 0;
        w_count <= 0;
        z <= 0;
      end else if (state == B) begin
        if (cycle_count < 2) begin
          cycle_count <= cycle_count + 1;
          w_count <= w_count + w; // add 1 if w==1 else 0
          z <= 0;
        end else begin
          // After 3rd cycle (0,1,2), output z=1 if w_count + current w == 2
          // Because this is the 3rd cycle, add w first
          // We output z on this cycle (following cycle in problem? 
          // problem says z to be set in following clock cycle after counting 3 cycles)
          // So we do counting here, then output z next cycle, so we need a flag
          cycle_count <= 0;
          w_count <= 0;
          z <= 0; // z set in next cycle by separate logic
        end
      end else begin
        z <= 0;
      end
    end
  end

  // Next state logic and z output logic
  // We'll implement output z logic with a registered flag that captures if w=1 exactly twice in last 3 cycles
  reg [1:0] w_count_next_cycle;
  reg output_z_flag;

  always @(posedge clk) begin
    if (reset) begin
      output_z_flag <= 0;
      w_count_next_cycle <= 0;
    end else if (state == B) begin
      if (cycle_count == 2) begin
        // Count w for this cycle + previous counts
        w_count_next_cycle <= w_count + w;
        // Set output flag for next cycle based on exactly two 1's
        output_z_flag <= (w_count + w == 2);
      end else begin
        output_z_flag <= 0;
      end
    end else begin
      output_z_flag <= 0;
      w_count_next_cycle <= 0;
    end
  end

  // z output register (z is set in the cycle after counting three w's)
  always @(posedge clk) begin
    if (reset) begin
      z <= 0;
    end else begin
      z <= output_z_flag;
    end
  end

  // Next state combinational logic
  always @(*) begin
    case (state)
      A: begin
        if (s == 1)
          next_state = B;
        else
          next_state = A;
      end
      B: begin
        next_state = B; // stays in B indefinitely
      end
      default: next_state = A;
    endcase
  end

endmodule
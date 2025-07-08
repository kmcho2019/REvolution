module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State encoding
localparam A         = 3'd0; // reset state
localparam PULSE_F   = 3'd1; // output f=1 for one cycle after reset deasserted
localparam MONITOR_X_0 = 3'd2; // waiting for first '1' in sequence
localparam MONITOR_X_1 = 3'd3; // got '1', waiting for '0'
localparam MONITOR_X_2 = 3'd4; // got '1','0', waiting for last '1'
localparam SET_G_HIGH = 3'd5;  // set g=1 for one cycle, then monitor y
localparam MONITOR_Y  = 3'd6;  // monitor y for 2 cycles
localparam FINAL_G_HIGH = 3'd7; // g=1 permanently
localparam FINAL_G_LOW  = 3'd0; // g=0 permanently - reuse state A

reg [2:0] state, next_state;
reg [1:0] y_counter; // count number of cycles monitoring y

always @(posedge clk) begin
  if (!resetn) begin
    state <= A;
    f <= 1'b0;
    g <= 1'b0;
    y_counter <= 2'd0;
  end else begin
    state <= next_state;
    // Default outputs
    f <= 1'b0;

    case(state)
      A: begin
        // stay here while resetn=0 (already handled by reset)
        f <= 1'b0;
        g <= 1'b0;
        y_counter <= 2'd0;
      end
      PULSE_F: begin
        f <= 1'b1; // output f=1 for this cycle
        g <= 1'b0;
      end
      MONITOR_X_0: begin
        f <= 1'b0;
        g <= 1'b0;
      end
      MONITOR_X_1: begin
        f <= 1'b0;
        g <= 1'b0;
      end
      MONITOR_X_2: begin
        f <= 1'b0;
        g <= 1'b0;
      end
      SET_G_HIGH: begin
        f <= 1'b0;
        g <= 1'b1; // g=1 for one cycle
      end
      MONITOR_Y: begin
        f <= 1'b0;
        // g depends on final decision, keep g=1 for now
        g <= 1'b1;
        y_counter <= y_counter + 1'b1;
      end
      FINAL_G_HIGH: begin
        f <= 1'b0;
        g <= 1'b1;
      end
      FINAL_G_LOW: begin
        f <= 1'b0;
        g <= 1'b0;
      end
      default: begin
        f <= 1'b0;
        g <= 1'b0;
      end
    endcase
  end
end

// Next state logic
always @(*) begin
  next_state = state;
  case(state)
    A: begin
      if (resetn) next_state = PULSE_F;
      else next_state = A;
    end
    PULSE_F: begin
      next_state = MONITOR_X_0;
    end
    MONITOR_X_0: begin
      // Wait for x=1 to start sequence
      if (x == 1'b1) next_state = MONITOR_X_1;
      else next_state = MONITOR_X_0;
    end
    MONITOR_X_1: begin
      // Next x should be 0
      if (x == 1'b0) next_state = MONITOR_X_2;
      else if (x == 1'b1) next_state = MONITOR_X_1; // stay, looking for 0 next
      else next_state = MONITOR_X_0; // reset sequence if something else
    end
    MONITOR_X_2: begin
      // Next x should be 1 to complete sequence
      if (x == 1'b1) next_state = SET_G_HIGH;
      else if (x == 1'b0) next_state = MONITOR_X_0; // restart search
      else next_state = MONITOR_X_0;
    end
    SET_G_HIGH: begin
      next_state = MONITOR_Y;
    end
    MONITOR_Y: begin
      // Monitor y for up to 2 cycles
      if (y == 1'b1) next_state = FINAL_G_HIGH;
      else if (y_counter == 2) next_state = FINAL_G_LOW;
      else next_state = MONITOR_Y;
    end
    FINAL_G_HIGH: begin
      next_state = FINAL_G_HIGH; // permanent
    end
    FINAL_G_LOW: begin
      next_state = FINAL_G_LOW;  // permanent
    end
    default: next_state = A;
  endcase
end

endmodule
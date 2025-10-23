module TopModule(
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output reg walk_left,
  output reg walk_right,
  output reg aaah,
  output reg digging
);

  // States encoding
  localparam WALK_LEFT     = 3'd0;
  localparam WALK_RIGHT    = 3'd1;
  localparam FALLING_LEFT  = 3'd2;
  localparam FALLING_RIGHT = 3'd3;
  localparam DIGGING_LEFT  = 3'd4;
  localparam DIGGING_RIGHT = 3'd5;
  localparam SPLATTERED    = 3'd6;

  reg [2:0] state, next_state;

  // Fall counter
  reg [4:0] fall_count; // count up to >20

  // Asynchronous reset, synchronous state update
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_count <= 5'd0;
    end else begin
      state <= next_state;
      if (state == FALLING_LEFT || state == FALLING_RIGHT) begin
        if (ground == 0)
          fall_count <= fall_count + 1'b1;
        else
          fall_count <= 5'd0;
      end else begin
        fall_count <= 5'd0;
      end
    end
  end

  // Next state logic (Moore FSM)
  always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
      WALK_LEFT: begin
        if (ground == 0) begin
          next_state = FALLING_LEFT; // Fall overrides dig and bump
        end else if (dig == 1) begin
          next_state = DIGGING_LEFT; // dig if on ground and walking
        end else if (bump_left || bump_right) begin
          // Switch direction on bump
          next_state = WALK_RIGHT;
        end
      end
      WALK_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
        end else if (dig == 1) begin
          next_state = DIGGING_RIGHT;
        end else if (bump_left || bump_right) begin
          next_state = WALK_LEFT;
        end
      end
      DIGGING_LEFT: begin
        if (ground == 0) begin
          next_state = FALLING_LEFT;
        end
        // else continue digging, ignore bumps and dig signal
      end
      DIGGING_RIGHT: begin
        if (ground == 0) begin
          next_state = FALLING_RIGHT;
        end
      end
      FALLING_LEFT: begin
        if (ground == 1) begin
          // Check fall_count for splatter
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_LEFT;
          end
        end
      end
      FALLING_RIGHT: begin
        if (ground == 1) begin
          if (fall_count > 5'd20) begin
            next_state = SPLATTERED;
          end else begin
            next_state = WALK_RIGHT;
          end
        end
      end
      SPLATTERED: begin
        // Stay splattered forever until reset
        next_state = SPLATTERED;
      end
      default: begin
        next_state = WALK_LEFT;
      end
    endcase
  end

  // Output logic (Moore outputs)
  always @(*) begin
    // Default all outputs zero
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
      WALK_LEFT: begin
        walk_left = 1'b1;
      end
      WALK_RIGHT: begin
        walk_right = 1'b1;
      end
      DIGGING_LEFT: begin
        digging = 1'b1;
        walk_left = 1'b1;  // keep walking direction output while digging
      end
      DIGGING_RIGHT: begin
        digging = 1'b1;
        walk_right = 1'b1;
      end
      FALLING_LEFT: begin
        aaah = 1'b1;
      end
      FALLING_RIGHT: begin
        aaah = 1'b1;
      end
      SPLATTERED: begin
        // All outputs remain zero
      end
      default: begin
        // Should not happen; no outputs set
      end
    endcase
  end

endmodule
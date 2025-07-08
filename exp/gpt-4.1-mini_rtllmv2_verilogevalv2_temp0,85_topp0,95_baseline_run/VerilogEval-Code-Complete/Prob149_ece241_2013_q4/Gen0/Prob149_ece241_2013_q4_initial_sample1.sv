module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  // Define states for water level (encoding 2 bits for simplicity)
  // 0 = Above s[3]       (all s asserted)
  // 1 = Between s[3] and s[2]
  // 2 = Between s[2] and s[1]
  // 3 = Below s[1]       (no sensors asserted)
  reg [1:0] state, next_state;
  reg [1:0] prev_state;

  // Determine next_state based on sensors
  // Sensor pattern: s[3] s[2] s[1]
  // Above s[3]: s[3]=1, s[2]=1, s[1]=1
  // Between s[3] and s[2]: s[3]=0, s[2]=1, s[1]=1
  // Between s[2] and s[1]: s[3]=0, s[2]=0, s[1]=1
  // Below s[1]: s[3]=0, s[2]=0, s[1]=0

  always @(*) begin
    case ({s[3], s[2], s[1]})
      3'b111: next_state = 2'd0; // Above s[3]
      3'b011: next_state = 2'd1; // Between s[3] and s[2]
      3'b001: next_state = 2'd2; // Between s[2] and s[1]
      3'b000: next_state = 2'd3; // Below s[1]
      // For other combinations, default to closest lower level:
      3'b110: next_state = 2'd1; // treat as Between s[3] and s[2]
      3'b010: next_state = 2'd2; // treat as Between s[2] and s[1]
      3'b100: next_state = 2'd1; // treat as Between s[3] and s[2]
      3'b101: next_state = 2'd1; // treat as Between s[3] and s[2]
      3'b111: next_state = 2'd0;
      default: next_state = 2'd3; // fallback to below s[1]
    endcase
  end

  // On clock, update state and prev_state
  always @(posedge clk) begin
    if (reset) begin
      state <= 2'd3;      // Start at Below s[1]
      prev_state <= 2'd3; // Previous also Below s[1]
    end else begin
      prev_state <= state;
      state <= next_state;
    end
  end

  // Set outputs based on state and transition direction
  always @(*) begin
    // Default all outputs low (valves closed, flow zero)
    fr1 = 0;
    fr2 = 0;
    fr3 = 0;
    dfr = 0;

    case (state)
      2'd0: begin
        // Above s[3], no flow
        fr1 = 0; fr2 = 0; fr3 = 0;
        dfr = 0;
      end
      2'd1: begin
        // Between s[3] and s[2], nominal flow fr1 only
        fr1 = 1; fr2 = 0; fr3 = 0;
        // If rising (prev_state > current), open supplemental valve
        dfr = (prev_state > state) ? 1 : 0;
      end
      2'd2: begin
        // Between s[2] and s[1], nominal flow fr1, fr2
        fr1 = 1; fr2 = 1; fr3 = 0;
        dfr = (prev_state > state) ? 1 : 0;
      end
      2'd3: begin
        // Below s[1], max flow fr1, fr2, fr3 all on
        fr1 = 1; fr2 = 1; fr3 = 1;
        dfr = 1; // dfr on always at lowest level as "previous was lower"
      end
      default: begin
        fr1 = 0; fr2 = 0; fr3 = 0; dfr = 0;
      end
    endcase
  end

endmodule
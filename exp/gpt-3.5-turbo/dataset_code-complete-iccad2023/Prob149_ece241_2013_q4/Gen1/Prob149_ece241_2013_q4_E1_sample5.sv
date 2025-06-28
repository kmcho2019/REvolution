module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// State definitions
parameter ABOVE_S3 = 3'b100;
parameter BETWEEN_S3_S2 = 3'b010;
parameter BETWEEN_S2_S1 = 3'b001;
parameter BELOW_S1 = 3'b000;

// Previous states for change detection
reg [3:1] prev_sensors;
reg [3:1] current_sensors;
reg [2:0] decline_counter;
reg [1:0] state, next_state;

always @* begin
  current_sensors = s;
end

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= BELOW_S1;
    decline_counter <= 0;
  end else begin
    state <= next_state;
  end
end

always @* begin
  next_state = state; // Default to current state

  // Detect sensor change
  if (current_sensors[3] && !prev_sensors[3]) begin
    next_state = ABOVE_S3;
  end else if (current_sensors[2] && !prev_sensors[2]) begin
    next_state = BETWEEN_S3_S2;
  end else if (current_sensors[1] && !prev_sensors[1]) begin
    next_state = BETWEEN_S2_S1;
  end else if (!current_sensors[1] && (prev_sensors[1] || prev_sensors[2] || prev_sensors[3])) begin
    decline_counter <= decline_counter + 1;
    if (decline_counter >= 2) begin
      next_state = BELOW_S1;
      decline_counter <= 0; // Reset counter after reaching below s[1] state
    end
  end
end

always @* begin
  case (state)
    ABOVE_S3: begin
      fr3 = 0;
      fr2 = 0;
      fr1 = 0;
      dfr = 0;
    end
    BETWEEN_S3_S2: begin
      fr3 = 0;
      fr2 = 1;
      fr1 = 0;
      dfr = 0;
    end
    BETWEEN_S2_S1: begin
      fr3 = 0;
      fr2 = 1;
      fr1 = 1;
      if (current_sensors[1] && !prev_sensors[2]) begin
        dfr = 1;
      end else begin
        dfr = 0;
      end
    end
    BELOW_S1: begin
      fr3 = 1;
      fr2 = 1;
      fr1 = 1;
      dfr = 1;
    end
    default: begin
      fr3 = 1;
      fr2 = 1;
      fr1 = 1;
      dfr = 1;
    end
  endcase
end

always @* begin
  prev_sensors = current_sensors;
end

endmodule
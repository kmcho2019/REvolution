module TopModule (
  input clk,
  input resetn,
  input [3:1] r,
  output reg [3:1] g
);

// State encoding
parameter IDLE = 2'b00;
parameter DEV1 = 2'b01;
parameter DEV2 = 2'b10;
parameter DEV3 = 2'b11;

reg [1:0] state, next_state;

always @(*) begin
  case(state)
    IDLE: begin
      if (r[1] == 1) next_state = DEV1;
      else if (r[2] == 1) next_state = DEV2;
      else if (r[3] == 1) next_state = DEV3;
      else next_state = IDLE;
    end
    DEV1: begin
      if (r[1] == 1) next_state = DEV1;
      else next_state = IDLE;
    end
    DEV2: begin
      if (r[2] == 1) next_state = DEV2;
      else next_state = IDLE;
    end
    DEV3: begin
      next_state = IDLE;
    end
    default: next_state = IDLE;
  endcase
end

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= IDLE;
    g <= 3'b000;
  end
  else begin
    state <= next_state;
    case(state)
      IDLE: g <= 3'b000; // No grants
      DEV1: g <= 3'b100; // Grant for device 1
      DEV2: g <= 3'b010; // Grant for device 2
      DEV3: g <= 3'b001; // Grant for device 3
    endcase
  end
end

endmodule
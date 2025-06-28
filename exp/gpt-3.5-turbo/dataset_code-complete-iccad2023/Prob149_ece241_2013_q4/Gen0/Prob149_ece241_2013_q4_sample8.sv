module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Define state machine states
parameter IDLE = 2'b00;
parameter ABOVE_S3 = 2'b01;
parameter BETWEEN_S3_S2 = 2'b10;
parameter BETWEEN_S2_S1 = 2'b11;

// Define nominal flow rates
parameter FR1 = 1'b1;
parameter FR2 = 1'b1;
parameter FR3 = 1'b1;

reg [1:0] state, next_state;

always @ (posedge clk) begin
  if (reset) begin
    state <= IDLE;
  end else begin
    state <= next_state;
  end
end

always @ (*) begin
  case(state)
    IDLE: begin
      if (s[1]) begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= 0;
        dfr <= 1;
        next_state <= ABOVE_S3;
      end else begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= FR3;
        dfr <= 1;
        next_state <= IDLE;
      end
    end
    ABOVE_S3: begin
      if (!s[3]) begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= FR3;
        dfr <= 1;
        next_state <= BETWEEN_S3_S2;
      end else begin
        fr1 <= 0;
        fr2 <= 0;
        fr3 <= 0;
        dfr <= 0;
        next_state <= ABOVE_S3;
      end
    end
    BETWEEN_S3_S2: begin
      if (!s[2]) begin
        fr1 <= FR1;
        fr2 <= FR1;
        fr3 <= 0;
        dfr <= 1;
        next_state <= BETWEEN_S2_S1;
      end else begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= FR3;
        dfr <= 1;
        next_state <= BETWEEN_S3_S2;
      end
    end
    BETWEEN_S2_S1: begin
      if (!s[1]) begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= FR1;
        dfr <= 1;
        next_state <= IDLE;
      end else begin
        fr1 <= FR1;
        fr2 <= FR2;
        fr3 <= FR3;
        dfr <= 1;
        next_state <= BETWEEN_S2_S1;
      end
    end
  endcase
end

endmodule
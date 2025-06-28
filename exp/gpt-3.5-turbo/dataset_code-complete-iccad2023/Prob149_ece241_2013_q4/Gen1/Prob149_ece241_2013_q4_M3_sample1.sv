module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Define states for the state machine
parameter ABOVE_S3 = 2'b00;
parameter BETWEEN_S3_S2 = 2'b01;
parameter BETWEEN_S2_S1 = 2'b10;
parameter BELOW_S1 = 2'b11;

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b11; // Set initial state to 'below s[1]'
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case(state)
    ABOVE_S3: begin
      if (s[3]) begin
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end else if (s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = BETWEEN_S3_S2;
      end else begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 1;
        dfr = 1;
        next_state = BETWEEN_S2_S1;
      end
    end
    BETWEEN_S3_S2: begin
      if (!s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end else if (!s[1]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 1;
        dfr = 0;
        next_state = BETWEEN_S3_S2;
      end
    end
    BETWEEN_S2_S1: begin
      if (!s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = ABOVE_S3;
      end else if (s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 1;
        dfr = 0;
        next_state = BETWEEN_S2_S1;
      end
    end
    BELOW_S1: begin
      if (s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = BETWEEN_S2_S1;
      end
    end
  endcase
end

endmodule
module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

reg [1:0] state, next_state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 2'b11; // Initialize to 'below s[1]' state
  end else begin
    state <= next_state;
  end
end

always @(*) begin
  case (state)
    2'b00: begin // ABOVE_S3 state
      if (s[3]) begin
        fr3 = 0;
        fr2 = 0;
        fr1 = 0;
        dfr = 0;
        next_state = 2'b00;
      end else if (s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = 2'b01;
      end else begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 1;
        dfr = 1;
        next_state = 2'b10;
      end
    end
    2'b01: begin // BETWEEN_S3_S2 state
      if (!s[2]) begin
        fr3 = 0;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = 2'b00;
      end
    end
    2'b10: begin // BETWEEN_S2_S1 state
      if (!s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = 2'b00;
      end
    end
    2'b11: begin // BELOW_S1 state
      if (s[1]) begin
        fr3 = 1;
        fr2 = 1;
        fr1 = 0;
        dfr = 0;
        next_state = 2'b10;
      end
    end
  endcase
end

endmodule
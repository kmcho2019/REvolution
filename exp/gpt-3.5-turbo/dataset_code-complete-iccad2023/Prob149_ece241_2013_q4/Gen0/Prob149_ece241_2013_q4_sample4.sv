module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

  parameter ABOVE_S3 = 3'b111;
  parameter BETWEEN_S3_S2 = 3'b110;
  parameter BETWEEN_S2_S1 = 3'b100;
  parameter BELOW_S1 = 3'b000;
  
  reg [2:0] state;
  reg [2:0] prev_state;
  
  always @ (posedge clk) begin
    if (reset) begin
      state <= BELOW_S1; // Reset state machine
      fr3 <= 1'b1;
      fr2 <= 1'b1;
      fr1 <= 1'b1;
      dfr <= 1'b1;
    end else begin
      prev_state <= state;
      
      case (state)
        ABOVE_S3: begin
          if (s == BETWEEN_S3_S2)
            state <= BETWEEN_S3_S2;
          else if (s == BETWEEN_S2_S1)
            state <= BETWEEN_S2_S1;
          else if (s == BELOW_S1)
            state <= BELOW_S1;
        end
        BETWEEN_S3_S2: begin
          if (s == ABOVE_S3)
            state <= ABOVE_S3;
          else if (s == BETWEEN_S2_S1)
            state <= BETWEEN_S2_S1;
          else if (s == BELOW_S1)
            state <= BELOW_S1;
        end
        BETWEEN_S2_S1: begin
          if (s == ABOVE_S3)
            state <= ABOVE_S3;
          else if (s == BETWEEN_S3_S2)
            state <= BETWEEN_S3_S2;
          else if (s == BELOW_S1)
            state <= BELOW_S1;
        end
        BELOW_S1: begin
          if (s == ABOVE_S3)
            state <= ABOVE_S3;
          else if (s == BETWEEN_S3_S2)
            state <= BETWEEN_S3_S2;
          else if (s == BETWEEN_S2_S1)
            state <= BETWEEN_S2_S1;
        end
        default: state <= BELOW_S1;
      endcase
    end
  end
  
  always @* begin
    case (state)
      ABOVE_S3: begin
        fr3 <= 1'b0;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b0;
      end
      BETWEEN_S3_S2: begin
        fr3 <= 1'b1;
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        dfr <= (prev_state == BELOW_S1) ? 1'b1 : 1'b0;
      end
      BETWEEN_S2_S1: begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b0;
        dfr <= (prev_state == BELOW_S1) ? 1'b1 : 1'b0;
      end
      BELOW_S1: begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b0;
      end
      default: begin
        fr3 <= 1'b1;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        dfr <= 1'b1;
      end
    endcase
  end
  
endmodule
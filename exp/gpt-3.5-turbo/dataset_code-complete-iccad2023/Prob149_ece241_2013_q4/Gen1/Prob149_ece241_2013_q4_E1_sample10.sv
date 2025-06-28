module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

// Flow rate calculation based on the sensor inputs and previous state
always @* begin
  case({s, state})
    7'b1_---_---: begin // Water level above s[3]
      fr3 = 1'b0;
      fr2 = 1'b0;
      fr1 = 1'b0;
      dfr = 1'b0;
    end
    7'b0_1_---_10: begin // Water level between s[3] and s[2]
      fr3 = 1'b0;
      fr2 = 1'b1;
      fr1 = 1'b0;
      dfr = 1'b0;
    end
    7'b0_0_1_1_00: begin // Water level between s[2] and s[1]
      fr3 = 1'b0;
      fr2 = 1'b1;
      fr1 = 1'b1;
      dfr = 1'b1;
    end
    7'b---_00_0_0: begin // Water level below s[1]
      fr3 = 1'b1;
      fr2 = 1'b1;
      fr1 = 1'b1;
      dfr = 1'b1;
    end
    default: begin // Default state if no match
      fr3 = 1'b1;
      fr2 = 1'b1;
      fr1 = 1'b1;
      dfr = 1'b1;
    end
  endcase
end

endmodule
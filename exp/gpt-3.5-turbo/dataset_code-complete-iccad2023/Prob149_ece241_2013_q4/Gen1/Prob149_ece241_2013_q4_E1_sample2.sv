module TopModule (
  input clk,
  input reset,
  input [3:1] s,
  output reg fr3,
  output reg fr2,
  output reg fr1,
  output reg dfr
);

always @* begin
  fr3 = 1'b0;
  fr2 = 1'b0;
  fr1 = 1'b0;
  dfr = 1'b0;

  if (reset) begin
    fr3 = 1'b1;
    fr2 = 1'b1;
    fr1 = 1'b1;
    dfr = 1'b1;
  end else begin
    case({s, s, s}) // Concatenating the sensors to simplify comparisons
      3'b111: ; // Water level above s[3] - No flow
      3'b110: fr1 = 1'b1; // Between s[3] and s[2] - fr1 flow
      3'b100: begin // Water level below s[2]
        fr1 = 1'b1;
        fr2 = 1'b1; // Initial assumption for fr2 flow
        if (s[1]) begin
          fr2 = 1'b1;
          dfr = 1'b1; // Supplemental flow valve opened
        end
      end
      default: ; // Water level below s[1]
    endcase
  end
end

endmodule
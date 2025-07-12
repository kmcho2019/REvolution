module TopModule(
  input  clk,
  input  reset,
  input  [2:0] s,
  output fr2,
  output fr1,
  output fr0,
  output dfr
);

reg [2:0] prev_s; // previous sensor state
reg [2:0] curr_s; // current sensor state
reg fr2_reg, fr1_reg, fr0_reg, dfr_reg; // registered outputs

always @(*) begin
  // determine current state based on sensor inputs
  casez ({s[2], s[1], s[0]})
    3'b111: curr_s = 3'b000; // above s[2]
    3'b110: curr_s = 3'b001; // between s[2] and s[1]
    3'b100: curr_s = 3'b010; // between s[1] and s[0]
    3'b0??: curr_s = 3'b111; // below s[0]
    default: curr_s = 3'b111; // default to below s[0]
  endcase
end

always @(posedge clk or posedge reset) begin
  if (reset) begin
    // reset to state equivalent to low water level
    prev_s <= 3'b000;
    fr2_reg <= 1'b1;
    fr1_reg <= 1'b1;
    fr0_reg <= 1'b1;
    dfr_reg <= 1'b1;
  end else begin
    // update previous sensor state
    prev_s <= curr_s;
    
    // determine flow rate outputs based on current and previous states
    casez ({curr_s, prev_s})
      3'b000_000: begin // above s[2] and was above s[2]
        fr2_reg <= 1'b0;
        fr1_reg <= 1'b0;
        fr0_reg <= 1'b0;
        dfr_reg <= 1'b0;
      end
      3'b001_000, 3'b001_001, 3'b001_010, 3'b001_111: begin // between s[2] and s[1]
        fr2_reg <= 1'b0;
        fr1_reg <= 1'b0;
        fr0_reg <= 1'b1;
        dfr_reg <= (curr_s > prev_s) ? 1'b1 : 1'b0;
      end
      3'b010_000, 3'b010_001, 3'b010_010, 3'b010_111: begin // between s[1] and s[0]
        fr2_reg <= 1'b0;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= (curr_s > prev_s) ? 1'b1 : 1'b0;
      end
      3'b111_000, 3'b111_001, 3'b111_010, 3'b111_111: begin // below s[0]
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
      end
      default: begin
        fr2_reg <= 1'b1;
        fr1_reg <= 1'b1;
        fr0_reg <= 1'b1;
        dfr_reg <= 1'b1;
      end
    endcase
  end
end

assign fr2 = fr2_reg;
assign fr1 = fr1_reg;
assign fr0 = fr0_reg;
assign dfr = dfr_reg;

endmodule
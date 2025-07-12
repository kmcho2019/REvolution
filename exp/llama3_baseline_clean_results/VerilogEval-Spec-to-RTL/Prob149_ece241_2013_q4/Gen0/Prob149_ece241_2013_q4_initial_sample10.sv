module TopModule(
  input clk,
  input reset,
  input [2:0] s,
  output reg fr2,
  output reg fr1,
  output reg fr0,
  output reg dfr
);

always @(posedge clk or posedge reset) begin
  if (reset) begin
    fr2 <= 1'b1;
    fr1 <= 1'b1;
    fr0 <= 1'b1;
    dfr <= 1'b1;
  end else begin
    case ({s[2], s[1], s[0]})
      3'b111: begin // Above s[2]
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b0;
        dfr <= 1'b0;
      end
      3'b011: begin // Between s[2] and s[1]
        fr2 <= 1'b0;
        fr1 <= 1'b0;
        fr0 <= 1'b1;
        if ({s[2], s[1], s[0]} > {s[2], s[1], s[0]} - 1'b1) begin
          dfr <= 1'b1;
        end else begin
          dfr <= 1'b0;
        end
      end
      3'b001: begin // Between s[1] and s[0]
        fr2 <= 1'b0;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        if ({s[2], s[1], s[0]} > {s[2], s[1], s[0]} - 1'b1) begin
          dfr <= 1'b1;
        end else begin
          dfr <= 1'b0;
        end
      end
      default: begin // Below s[0]
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
      end
    endcase
  end
end

endmodule
module TopModule (
  input x,
  input y,
  output z
);

reg [6:0] count;

always @ (posedge clk) begin
  count <= count + 1;
  case(count)
    0: begin x <= 0; y <= 0; z <= 1; end
    5: begin x <= 0; y <= 0; z <= 1; end
    10: begin x <= 0; y <= 0; z <= 1; end
    15: begin x <= 0; y <= 0; z <= 1; end
    20: begin x <= 0; y <= 0; z <= 1; end
    25: begin x <= 1; y <= 0; z <= 0; end
    30: begin x <= 1; y <= 0; z <= 0; end
    35: begin x <= 0; y <= 1; z <= 0; end
    40: begin x <= 0; y <= 1; z <= 0; end
    45: begin x <= 1; y <= 1; z <= 1; end
    50: begin x <= 1; y <= 1; z <= 1; end
    55: begin x <= 0; y <= 0; z <= 1; end
    60: begin x <= 0; y <= 1; z <= 0; end
    65: begin x <= 0; y <= 1; z <= 0; end
    70: begin x <= 1; y <= 1; z <= 1; end
    75: begin x <= 0; y <= 1; z <= 0; end
    80: begin x <= 0; y <= 1; z <= 0; end
    85: begin x <= 0; y <= 1; z <= 0; end
    90: begin x <= 1; y <= 0; z <= 0; end
    default: begin x <= 0; y <= 0; z <= 0; end
  endcase
end

endmodule
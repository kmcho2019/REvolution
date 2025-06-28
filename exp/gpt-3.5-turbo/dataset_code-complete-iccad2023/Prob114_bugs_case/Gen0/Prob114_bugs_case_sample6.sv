module TopModule (
  input [7:0] code,
  output reg [3:0] out,
  output reg valid
);
  
  always @(*) begin
    case(code)
      8'h45: {out, valid} = {4'b0000, 1'b1}; // key 0
      8'h16: {out, valid} = {4'b0001, 1'b1}; // key 1
      8'h1e: {out, valid} = {4'b0010, 1'b1}; // key 2
      8'h26: {out, valid} = {4'b0011, 1'b1}; // key 3
      8'h25: {out, valid} = {4'b0100, 1'b1}; // key 4
      8'h2e: {out, valid} = {4'b0101, 1'b1}; // key 5
      8'h36: {out, valid} = {4'b0110, 1'b1}; // key 6
      8'h3d: {out, valid} = {4'b0111, 1'b1}; // key 7
      8'h3e: {out, valid} = {4'b1000, 1'b1}; // key 8
      8'h46: {out, valid} = {4'b1001, 1'b1}; // key 9
      default: {out, valid} = {4'b0000, 1'b0}; // default case
    endcase
  end

endmodule
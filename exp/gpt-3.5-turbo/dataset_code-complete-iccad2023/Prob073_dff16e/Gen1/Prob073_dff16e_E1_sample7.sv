module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);
  reg [15:0] q_reg; // Internal register to hold the values
  
  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin // Active-low synchronous reset
      q_reg <= 16'b0;
    end else begin
      // Update q_reg based on byteena
      case(byteena)
        2'b01: q_reg[7:0] <= d[7:0]; // Update lower byte when byteena[0] is set
        2'b10: q_reg[15:8] <= d[15:8]; // Update upper byte when byteena[1] is set
        2'b11: q_reg <= d; // Update all when both byte enables are set
        default: // Do nothing
      endcase
    end
  end
  
  assign q = q_reg;
  
endmodule
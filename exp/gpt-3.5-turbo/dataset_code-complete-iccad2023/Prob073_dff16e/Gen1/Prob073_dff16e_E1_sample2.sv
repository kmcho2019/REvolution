module TopModule (
  input clk,
  input resetn,
  input [1:0] byteena,
  input [15:0] d,
  output reg [15:0] q
);

reg [15:0] q_reg;

always @(posedge clk or negedge resetn) begin
  if (~resetn) begin
    q_reg <= 16'd0;
  end else begin
    // Temporary register to hold the current values of flip-flops
    reg [15:0] temp_reg;
    temp_reg = q_reg; // Store current flip-flop values
    
    // Selective update of specific bytes based on byte-enable signals
    if (byteena[0]) begin
      temp_reg[7:0] <= d[7:0]; // Update lower byte if byteena[0] is set
    end
    if (byteena[1]) begin
      temp_reg[15:8] <= d[15:8]; // Update upper byte if byteena[1] is set
    end
    
    // Assign the updated values back to the main register on the next clock cycle
    q_reg <= temp_reg;
  end
end

assign q = q_reg;

endmodule
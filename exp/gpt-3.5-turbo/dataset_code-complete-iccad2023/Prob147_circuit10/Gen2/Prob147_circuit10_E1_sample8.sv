module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg [1:0] sequence_reg;
reg detect_flag;

always @(posedge clk) begin
    if (!detect_flag && a == 0 && b == 1) begin
        sequence_reg <= 2'b01;
        detect_flag <= 1;
    end
    else if (detect_flag) begin
        sequence_reg <= 2'b01;
        detect_flag <= 0;
    end
    else begin
        sequence_reg <= {sequence_reg[0], a};
    end
end

assign state = (sequence_reg == 2'b01) ? 1 : 0;
assign q = sequence_reg[1];

endmodule
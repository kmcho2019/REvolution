module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [63:0] q_reg;

// Divide the 64-bit data into 8 segments of 8 bits each
wire [7:0] segment0, segment1, segment2, segment3, segment4, segment5, segment6, segment7;
assign segment0 = q_reg[7:0];
assign segment1 = q_reg[15:8];
assign segment2 = q_reg[23:16];
assign segment3 = q_reg[31:24];
assign segment4 = q_reg[39:32];
assign segment5 = q_reg[47:40];
assign segment6 = q_reg[55:48];
assign segment7 = q_reg[63:56];

// Perform the shift operation on each segment
wire [7:0] shifted_segment0, shifted_segment1, shifted_segment2, shifted_segment3, shifted_segment4, shifted_segment5, shifted_segment6, shifted_segment7;

always @(q_reg, amount) begin
  case (amount)
    2'b00: begin // Shift left by 1 bit
      shifted_segment0 = {q_reg[6:0], 1'b0};
      shifted_segment1 = {q_reg[14:7], 1'b0};
      shifted_segment2 = {q_reg[22:15], 1'b0};
      shifted_segment3 = {q_reg[30:23], 1'b0};
      shifted_segment4 = {q_reg[38:31], 1'b0};
      shifted_segment5 = {q_reg[46:39], 1'b0};
      shifted_segment6 = {q_reg[54:47], 1'b0};
      shifted_segment7 = {q_reg[62:55], 1'b0};
    end
    2'b01: begin // Shift left by 8 bits
      shifted_segment0 = 8'b0;
      shifted_segment1 = q_reg[7:0];
      shifted_segment2 = q_reg[15:8];
      shifted_segment3 = q_reg[23:16];
      shifted_segment4 = q_reg[31:24];
      shifted_segment5 = q_reg[39:32];
      shifted_segment6 = q_reg[47:40];
      shifted_segment7 = q_reg[55:48];
    end
    2'b10: begin // Shift right by 1 bit
      shifted_segment0 = {q_reg[7], q_reg[7:1]};
      shifted_segment1 = {q_reg[15], q_reg[15:8]};
      shifted_segment2 = {q_reg[23], q_reg[23:16]};
      shifted_segment3 = {q_reg[31], q_reg[31:24]};
      shifted_segment4 = {q_reg[39], q_reg[39:32]};
      shifted_segment5 = {q_reg[47], q_reg[47:40]};
      shifted_segment6 = {q_reg[55], q_reg[55:48]};
      shifted_segment7 = {q_reg[63], q_reg[63:56]};
    end
    2'b11: begin // Shift right by 8 bits
      shifted_segment0 = q_reg[63:56];
      shifted_segment1 = q_reg[63:56];
      shifted_segment2 = q_reg[63:56];
      shifted_segment3 = q_reg[63:56];
      shifted_segment4 = q_reg[63:56];
      shifted_segment5 = q_reg[63:56];
      shifted_segment6 = q_reg[63:56];
      shifted_segment7 = q_reg[63:56];
    end
    default: begin
      shifted_segment0 = segment0;
      shifted_segment1 = segment1;
      shifted_segment2 = segment2;
      shifted_segment3 = segment3;
      shifted_segment4 = segment4;
      shifted_segment5 = segment5;
      shifted_segment6 = segment6;
      shifted_segment7 = segment7;
    end
  endcase
end

// Reassemble the shifted segments
wire [63:0] next_q;
assign next_q = (load)? data :
                 (ena)? {
                   shifted_segment7,
                   shifted_segment6,
                   shifted_segment5,
                   shifted_segment4,
                   shifted_segment3,
                   shifted_segment2,
                   shifted_segment1,
                   shifted_segment0
                 } :
                 q_reg;

always @(posedge clk) begin
  q_reg <= next_q;
end

assign q = q_reg;

endmodule
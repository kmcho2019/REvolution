module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

reg [7:0] q_seg [7:0];

always @(posedge clk) begin
  if (load) begin
    for (int i = 0; i < 8; i++) begin
      q_seg[i] <= data[(i*8)+:8];
    end
  end else if (ena) begin
    case (amount)
      2'b00: begin // shift left by 1 bit
        for (int i = 0; i < 7; i++) begin
          q_seg[i] <= {q_seg[i][6:0], q_seg[i+1][7]};
        end
        q_seg[7] <= {q_seg[7][6:0], 1'b0};
      end
      2'b01: begin // shift left by 8 bits
        for (int i = 0; i < 7; i++) begin
          q_seg[i] <= q_seg[i+1];
        end
        q_seg[7] <= 8'b0;
      end
      2'b10: begin // shift right by 1 bit
        for (int i = 7; i > 0; i--) begin
          q_seg[i] <= {q_seg[i-1][0], q_seg[i][7:1]};
        end
        q_seg[0] <= {q_seg[0][7], q_seg[0][7:1]};
      end
      2'b11: begin // shift right by 8 bits
        for (int i = 7; i > 0; i--) begin
          q_seg[i] <= q_seg[i-1];
        end
        q_seg[0] <= {8{q_seg[0][7]}};
      end
    endcase
  end
end

assign q = {q_seg[7], q_seg[6], q_seg[5], q_seg[4], q_seg[3], q_seg[2], q_seg[1], q_seg[0]};

endmodule
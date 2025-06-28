module BCD_Counter (
  input clk,
  input reset,
  output reg [3:1] ena,
  output reg [15:0] q
);

reg [3:0] q_temp;
reg [3:0] ena_temp;

always @ (posedge clk) begin
  if (reset) begin
    q <= 16'b0;
    ena <= 4'b0;
  end else begin
    if (q_temp[0] == 4'b1001) begin
      q_temp[0] <= 4'b0000;
      ena_temp[0] <= 1'b1;
      ena_temp[1] <= 1'b1;
    end else begin
      ena_temp[0] <= 1'b0;
    end

    if (q_temp[1] == 4'b1001) begin
      q_temp[1] <= 4'b0000;
      ena_temp[1] <= 1'b1;
      ena_temp[2] <= 1'b1;
    end else begin
      ena_temp[1] <= 1'b0;
    end

    if (q_temp[2] == 4'b1001) begin
      q_temp[2] <= 4'b0000;
      ena_temp[2] <= 1'b1;
      ena_temp[3] <= 1'b1;
    end else begin
      ena_temp[2] <= 1'b0;
    end

    if (q_temp[3] == 4'b1001) begin
      q_temp[3] <= 4'b0000;
      ena_temp[3] <= 1'b1;
    end else begin
      ena_temp[3] <= 1'b0;
    end

    for (int i=0; i<4; i=i+1) begin
      if (ena_temp[i]) begin
        q_temp[i] <= q_temp[i] + 1;
      end
    end

    q <= {q_temp[3], q_temp[2], q_temp[1], q_temp[0]};
    ena <= ena_temp;
  end
end

endmodule
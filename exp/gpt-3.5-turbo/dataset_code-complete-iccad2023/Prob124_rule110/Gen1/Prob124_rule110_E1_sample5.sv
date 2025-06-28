module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Update boundary cell q[0] based on Rule 110 conditions
  always @* begin
    q[0] = (data[1] & data[0]) | (!data[0] & data[1]);
  end

  // Update internal cells based on Rule 110 conditions
  generate
    genvar i;
    for (i = 1; i < 511; i = i + 1) begin : rule110_logic
      always @* begin
        q[i] = (q[i-1] & !q[i]) | (!q[i-1] & q[i+1]);
      end
    end
  endgenerate

  // Update boundary cell q[511] based on Rule 110 conditions
  always @* begin
    q[511] = (!q[510] & q[511]) | (!q[510] & data[511]);
  end

  // Load data into the system when load signal is high
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule
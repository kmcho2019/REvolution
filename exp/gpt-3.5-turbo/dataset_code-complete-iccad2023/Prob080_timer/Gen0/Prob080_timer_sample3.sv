module Timer (
  input clk,
  input load,
  input [9:0] data,
  output reg tc
);

  reg [9:0] counter;

  always @(posedge clk) begin
    if (load == 1) begin
      counter <= data;
    end 
    else begin
      if (counter > 0) begin
        counter <= counter - 1;
      end
    end
  end

  // Terminal count signal generation
  always @(*) begin
    if (counter == 0) begin
      tc = 1;
    end
    else begin
      tc = 0;
    end
  end

endmodule

module TopModule (
  input clk,
  input load,
  input [9:0] data,
  output tc
);

  Timer timer (
    .clk(clk),
    .load(load),
    .data(data),
    .tc(tc)
  );

endmodule
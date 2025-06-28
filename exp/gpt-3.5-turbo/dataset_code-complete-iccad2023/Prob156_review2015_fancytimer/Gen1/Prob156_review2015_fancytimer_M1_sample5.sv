module ShiftRegister (
  input wire clk,
  input wire reset,
  input wire [3:0] data_in,
  input wire shift_en,
  output reg [3:0] data_out
);

always_ff @ (posedge clk) begin
  if (reset) begin
    data_out <= 4'b0;
  end
  else if (shift_en) begin
    data_out <= {data_in, data_out[3:1]};
  end
end

endmodule

module Counter (
  input wire clk,
  input wire reset,
  input wire enable,
  input wire [3:0] load,
  output reg [3:0] count
);

always_ff @ (posedge clk) begin
  if (reset) begin
    count <= 4'b0;
  end
  else if (enable) begin
    if (count > 0) begin
      count <= count - 1;
    end
    else if (count == 0 && load > 0) begin
      count <= load;
    end
  end
end

endmodule

module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output wire [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

reg [3:0] delay;
reg [3:0] remaining_time;
reg previous_data;
reg start_search;

Counter counter_inst (
  .clk(clk),
  .reset(reset),
  .enable(counting),
  .load(delay),
  .count(remaining_time)
);

ShiftRegister shift_reg_inst (
  .clk(clk),
  .reset(reset),
  .data_in(data),
  .shift_en(start_search),
  .data_out(delay)
);

always @* begin
  counting = 0;
  count = (remaining_time > 0) ? remaining_time : 4'b0;

  case(state)
    // Same case statements as before
  endcase
end

endmodule
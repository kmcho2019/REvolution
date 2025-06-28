module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] shift_counter; // Counter to detect the sequence

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    shift_counter <= 4'b0;
    start_shifting <= 1'b0;
  end else begin
    if (data && shift_counter == 4'b1100) begin
      start_shifting <= 1'b1;
    end else if (shift_counter[2:0] == 3'b110) begin
      shift_counter <= shift_counter + 1;
    end else begin
      shift_counter <= {shift_counter[2:0], data};
    end
  end
end

endmodule
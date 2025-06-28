module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output reg [3:0] out
);

reg [7:0] sel_rem;
reg [7:0] selected_data [0:7];
integer i;

always @(*) begin
  sel_rem = sel % 8; // Determine which group of 4-bit data to select within each 8-bit segment
  for (i = 0; i < 8; i = i + 1) begin
    selected_data[i] = in[((sel/8)*8 + i)*4 +: 4]; // Extract the 4-bit data corresponding to the selected group
  end
  case(sel_rem)
    0: out = selected_data[0];
    1: out = selected_data[1];
    2: out = selected_data[2];
    3: out = selected_data[3];
    4: out = selected_data[4];
    5: out = selected_data[5];
    6: out = selected_data[6];
    7: out = selected_data[7];
    default: out = 4'b0000;
  endcase
end

endmodule
module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output [3:0] out
);
  
  reg [255:0] selected_input;

  always @* begin
    case(sel)
      8'h00: selected_input = in[3:0];
      8'h01: selected_input = in[7:4];
      8'h02: selected_input = in[11:8];
      // Add more cases for the remaining selections
      // ...
      default: selected_input = in[1023:1020];
    endcase
  end

  assign out = selected_input;

endmodule
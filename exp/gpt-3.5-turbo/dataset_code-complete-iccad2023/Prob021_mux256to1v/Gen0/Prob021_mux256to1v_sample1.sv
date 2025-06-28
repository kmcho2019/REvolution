module TopModule (
  input [1023:0] in,
  input [7:0] sel,
  output reg [3:0] out
);

always @(*) begin
    case(sel)
        8'b00000000: out = in[3:0];
        8'b00000001: out = in[7:4];
        8'b00000010: out = in[11:8];
        // Add cases for the remaining selection values
        
        default: out = 4'b0000; // Default output when sel is out of range
    endcase
end

endmodule
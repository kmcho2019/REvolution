module TopModule(
    input  [2:0] a,
    output [15:0] q
);

// Define the lookup tables for each range of input values
reg [15:0] lut0 = 16'h1232;
reg [15:0] lut1 = 16'haee0;
reg [15:0] lut2 = 16'h27d4;
reg [15:0] lut3 = 16'h5a0e;
reg [15:0] lut4 = 16'h2066;
reg [15:0] lut5 = 16'h64ce;
reg [15:0] lut6 = 16'hc526;
reg [15:0] lut7 = 16'h2f19;

// Use a case statement to select the appropriate LUT based on the input 'a'
always @(*) begin
    case (a)
        3'b000: q = lut0;
        3'b001: q = lut1;
        3'b010: q = lut2;
        3'b011: q = lut3;
        3'b100: q = lut4;
        3'b101: q = lut5;
        3'b110: q = lut6;
        3'b111: q = lut7;
        default: q = 16'h0000; // default value
    endcase
end

endmodule
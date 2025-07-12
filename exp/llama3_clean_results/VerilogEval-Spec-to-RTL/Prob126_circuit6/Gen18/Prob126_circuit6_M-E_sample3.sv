module TopModule(
    input  [2:0] a,
    output [15:0] q
);

// Define the lookup tables (LUTs) for each output segment
wire [3:0] lut0, lut1, lut2, lut3;
assign lut0 = (a == 3'b000) ? 4'h2 : 
               (a == 3'b001) ? 4'ha : 
               (a == 3'b010) ? 4'h2 : 
               (a == 3'b011) ? 4'h5 : 
               (a == 3'b100) ? 4'h2 : 
               (a == 3'b101) ? 4'h6 : 
               (a == 3'b110) ? 4'hc : 
               (a == 3'b111) ? 4'h2 : 4'h0;

assign lut1 = (a == 3'b000) ? 4'h3 : 
               (a == 3'b001) ? 4'he : 
               (a == 3'b010) ? 4'h7 : 
               (a == 3'b011) ? 4'ha : 
               (a == 3'b100) ? 4'h0 : 
               (a == 3'b101) ? 4'h4 : 
               (a == 3'b110) ? 4'h5 : 
               (a == 3'b111) ? 4'hf : 4'h0;

assign lut2 = (a == 3'b000) ? 4'h2 : 
               (a == 3'b001) ? 4'he : 
               (a == 3'b010) ? 4'h2 : 
               (a == 3'b011) ? 4'h0 : 
               (a == 3'b100) ? 4'h6 : 
               (a == 3'b101) ? 4'h6 : 
               (a == 3'b110) ? 4'h2 : 
               (a == 3'b111) ? 4'h1 : 4'h0;

assign lut3 = (a == 3'b000) ? 4'h1 : 
               (a == 3'b001) ? 4'h0 : 
               (a == 3'b010) ? 4'h4 : 
               (a == 3'b011) ? 4'he : 
               (a == 3'b100) ? 4'h6 : 
               (a == 3'b101) ? 4'he : 
               (a == 3'b110) ? 4'h1 : 
               (a == 3'b111) ? 4'h9 : 4'h0;

// Use multiplexers to select the appropriate output segment
assign q[3:0] = lut0;
assign q[7:4] = lut1;
assign q[11:8] = lut2;
assign q[15:12] = lut3;

endmodule
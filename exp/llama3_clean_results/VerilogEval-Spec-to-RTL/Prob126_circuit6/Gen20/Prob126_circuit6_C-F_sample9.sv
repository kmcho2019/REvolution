module TopModule(
    input  [2:0] a,
    output [15:0] q
);

// Define the output values for each input combination
localparam [15:0] output_0 = 16'h1232;
localparam [15:0] output_1 = 16'haee0;
localparam [15:0] output_2 = 16'h27d4;
localparam [15:0] output_3 = 16'h5a0e;
localparam [15:0] output_4 = 16'h2066;
localparam [15:0] output_5 = 16'h64ce;
localparam [15:0] output_6 = 16'hc526;
localparam [15:0] output_7 = 16'h2f19;

// Use the assign statement with conditional operators to generate the output values
assign q = (a == 3'b000) ? output_0 :
           (a == 3'b001) ? output_1 :
           (a == 3'b010) ? output_2 :
           (a == 3'b011) ? output_3 :
           (a == 3'b100) ? output_4 :
           (a == 3'b101) ? output_5 :
           (a == 3'b110) ? output_6 :
           (a == 3'b111) ? output_7 :
           16'h0000; // Default case, though not expected to occur

endmodule
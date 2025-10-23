module TopModule(
    input  [2:0] a,
    output [15:0] q
);

    // Define all output constants for inputs 0 to 7
    localparam [15:0] VAL0 = 16'h1232;
    localparam [15:0] VAL1 = 16'haee0;
    localparam [15:0] VAL2 = 16'h27d4;
    localparam [15:0] VAL3 = 16'h5a0e;
    localparam [15:0] VAL4 = 16'h2066;
    localparam [15:0] VAL5 = 16'h64ce;
    localparam [15:0] VAL6 = 16'hc526;
    localparam [15:0] VAL7 = 16'h2f19;

    // Use a balanced binary mux tree
    wire [15:0] mux0 = (a[0] == 1'b0) ? VAL0 : VAL1;
    wire [15:0] mux1 = (a[0] == 1'b0) ? VAL2 : VAL3;
    wire [15:0] mux2 = (a[0] == 1'b0) ? VAL4 : VAL5;
    wire [15:0] mux3 = (a[0] == 1'b0) ? VAL6 : VAL7;

    wire [15:0] mux4 = (a[1] == 1'b0) ? mux0 : mux1;
    wire [15:0] mux5 = (a[1] == 1'b0) ? mux2 : mux3;

    assign q = (a[2] == 1'b0) ? mux4 : mux5;

endmodule
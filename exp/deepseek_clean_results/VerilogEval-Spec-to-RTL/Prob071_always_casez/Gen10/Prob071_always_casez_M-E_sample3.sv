module TopModule (
    input [7:0] in,
    output [2:0] pos
);

// Step 1: Create thermometer-style vector
wire [7:0] therm;
assign therm[0] = in[0];
assign therm[1] = in[1] | therm[0];
assign therm[2] = in[2] | therm[1];
assign therm[3] = in[3] | therm[2];
assign therm[4] = in[4] | therm[3];
assign therm[5] = in[5] | therm[4];
assign therm[6] = in[6] | therm[5];
assign therm[7] = in[7] | therm[6];

// Step 2: Detect edges (0-to-1 transitions)
wire [6:0] edges;
assign edges[0] = ~therm[0] & therm[1];
assign edges[1] = ~therm[1] & therm[2];
assign edges[2] = ~therm[2] & therm[3];
assign edges[3] = ~therm[3] & therm[4];
assign edges[4] = ~therm[4] & therm[5];
assign edges[5] = ~therm[5] & therm[6];
assign edges[6] = ~therm[6] & therm[7];

// Step 3: Priority encode the edges
assign pos = edges[0] ? 3'd1 :
             edges[1] ? 3'd2 :
             edges[2] ? 3'd3 :
             edges[3] ? 3'd4 :
             edges[4] ? 3'd5 :
             edges[5] ? 3'd6 :
             edges[6] ? 3'd7 :
             3'd0;

endmodule
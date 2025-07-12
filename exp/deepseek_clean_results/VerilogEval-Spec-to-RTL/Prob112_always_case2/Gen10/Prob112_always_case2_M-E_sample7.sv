module TopModule (
    input [3:0] in,
    output [1:0] pos
);

wire [3:0] therm;
wire [3:0] transitions;

// Convert to thermometer code (all bits right of first '1' become '1')
assign therm = in | {1'b0, in[3:1]} | {2'b0, in[3:2]} | {3'b0, in[3]};

// Find transitions between bits (XOR adjacent bits)
assign transitions = therm ^ {therm[2:0], 1'b0};

// Encode the transition position
assign pos = transitions[3] ? 2'b11 :
             transitions[2] ? 2'b10 :
             transitions[1] ? 2'b01 :
             2'b00;  // Default case (all zeros or no transitions)

endmodule
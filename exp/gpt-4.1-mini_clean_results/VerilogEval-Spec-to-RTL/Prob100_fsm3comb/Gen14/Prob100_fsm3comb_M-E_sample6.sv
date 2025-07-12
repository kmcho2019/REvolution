module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // LUT indexed by {state, in}: 3 bits total
    // Each entry: [2:1] = next_state (2 bits), [0] = out (1 bit)
    // Encoding: bits [2:1] = next_state, bit [0] = output
    wire [2:0] lut [0:7];

    assign lut[3'b000] = 3'b000; // A,in=0: next_state=A(00), out=0
    assign lut[3'b001] = 3'b010; // A,in=1: next_state=B(01), out=0
    assign lut[3'b010] = 3'b100; // B,in=0: next_state=C(10), out=0
    assign lut[3'b011] = 3'b010; // B,in=1: next_state=B(01), out=0
    assign lut[3'b100] = 3'b000; // C,in=0: next_state=A(00), out=0
    assign lut[3'b101] = 3'b111; // C,in=1: next_state=D(11), out=0 (correct output bit 0)
    assign lut[3'b110] = 3'b100; // D,in=0: next_state=C(10), out=1 (need to fix output bit)
    assign lut[3'b111] = 3'b010; // D,in=1: next_state=B(01), out=1 (need to fix output bit)

    // Correcting the output bits for states D:
    // For D,in=0: next_state=C(10), out=1 → lut[110] = {next_state=2'b10, out=1} = 3'b101
    // For D,in=1: next_state=B(01), out=1 → lut[111] = {2'b01,1'b1} = 3'b011
    // So override those two entries accordingly:
    assign lut[3'b110] = 3'b101; // D,in=0
    assign lut[3'b111] = 3'b011; // D,in=1

    wire [2:0] entry = lut[{state, in}];

    assign next_state = entry[2:1];
    assign out = entry[0];

endmodule
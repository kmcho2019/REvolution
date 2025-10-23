module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// LUT implementation
// Format: {next_state, out}
// Address format: {state, in}
reg [2:0] lut [0:7];

// Initialize LUT
initial begin
    // Address {state, in} = 3'b000 (A, 0)
    lut[3'b000] = {2'b00, 1'b0}; // A -> A, out=0
    // 3'b001 (A, 1)
    lut[3'b001] = {2'b01, 1'b0}; // A -> B, out=0
    // 3'b010 (B, 0)
    lut[3'b010] = {2'b10, 1'b0}; // B -> C, out=0
    // 3'b011 (B, 1)
    lut[3'b011] = {2'b01, 1'b0}; // B -> B, out=0
    // 3'b100 (C, 0)
    lut[3'b100] = {2'b00, 1'b0}; // C -> A, out=0
    // 3'b101 (C, 1)
    lut[3'b101] = {2'b11, 1'b0}; // C -> D, out=0
    // 3'b110 (D, 0)
    lut[3'b110] = {2'b10, 1'b1}; // D -> C, out=1
    // 3'b111 (D, 1)
    lut[3'b111] = {2'b01, 1'b1}; // D -> B, out=1
end

// Output assignment
assign {next_state, out} = lut[{state, in}];

endmodule
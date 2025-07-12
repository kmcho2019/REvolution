module TopModule (
    input        in,
    input  [1:0] state,
    output reg [1:0] next_state,
    output reg       out
);

    // Define a combined input for LUT indexing: {state, in}
    wire [2:0] index = {state, in};

    // Define LUTs for next_state and output indexed by {state, in}
    // Order: index= {state[1:0], in}
    // States: A=00, B=01, C=10, D=11
    // LUT entries in order from index=0 to 7
    // index: state_in (in decimal)
    // 0: A,0 -> A(00), out=0
    // 1: A,1 -> B(01), out=0
    // 2: B,0 -> C(10), out=0
    // 3: B,1 -> B(01), out=0
    // 4: C,0 -> A(00), out=0
    // 5: C,1 -> D(11), out=0
    // 6: D,0 -> C(10), out=1
    // 7: D,1 -> B(01), out=1

    // next_state LUT (2 bits each)
    reg [1:0] next_state_lut [0:7];
    // output LUT (1 bit each)
    reg out_lut [0:7];

    // Initialize LUT values
    initial begin
        next_state_lut[0] = 2'b00; out_lut[0] = 1'b0; // A,0
        next_state_lut[1] = 2'b01; out_lut[1] = 1'b0; // A,1
        next_state_lut[2] = 2'b10; out_lut[2] = 1'b0; // B,0
        next_state_lut[3] = 2'b01; out_lut[3] = 1'b0; // B,1
        next_state_lut[4] = 2'b00; out_lut[4] = 1'b0; // C,0
        next_state_lut[5] = 2'b11; out_lut[5] = 1'b0; // C,1
        next_state_lut[6] = 2'b10; out_lut[6] = 1'b1; // D,0
        next_state_lut[7] = 2'b01; out_lut[7] = 1'b1; // D,1
    end

    always @* begin
        next_state = next_state_lut[index];
        out = out_lut[index];
    end

endmodule
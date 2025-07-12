module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Combine state and input to form a 3-bit index
    wire [2:0] idx = {state, in};

    // Transition and output table: 3 bits per entry: [2:1] = next_state, [0] = out
    // Index corresponds to concatenation {state, in}
    reg [2:0] trans_table [0:7];

    initial begin
        // Entries indexed by {state, in}
        // state A=00
        trans_table[3'b000] = 3'b000; // next_state=00 (A), out=0
        trans_table[3'b001] = 3'b010; // next_state=01 (B), out=0
        // state B=01
        trans_table[3'b010] = 3'b100; // next_state=10 (C), out=0
        trans_table[3'b011] = 3'b010; // next_state=01 (B), out=0
        // state C=10
        trans_table[3'b100] = 3'b000; // next_state=00 (A), out=0
        trans_table[3'b101] = 3'b111; // next_state=11 (D), out=1
        // state D=11
        trans_table[3'b110] = 3'b100; // next_state=10 (C), out=0
        trans_table[3'b111] = 3'b010; // next_state=01 (B), out=0
    end

    wire [2:0] combined = trans_table[idx];

    assign next_state = combined[2:1];
    assign out        = combined[0];

endmodule
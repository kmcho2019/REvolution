module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Priority encoder: convert one-hot to binary (2 bits)
    wire [1:0] curr_state_enc;
    assign curr_state_enc = (state[3]) ? 2'b11 : 
                          (state[2]) ? 2'b10 : 
                          (state[1]) ? 2'b01 : 
                                       2'b00;

    // Transition logic in encoded space
    wire [1:0] next_state_enc;
    assign next_state_enc = 
        (curr_state_enc == 2'b00) ? (in ? 2'b01 : 2'b00) : // A -> B or A
        (curr_state_enc == 2'b01) ? (in ? 2'b01 : 2'b10) : // B -> B or C
        (curr_state_enc == 2'b10) ? (in ? 2'b11 : 2'b00) : // C -> D or A
                                    (in ? 2'b01 : 2'b10);  // D -> B or C

    // One-hot decoder
    assign next_state[0] = (next_state_enc == 2'b00);
    assign next_state[1] = (next_state_enc == 2'b01);
    assign next_state[2] = (next_state_enc == 2'b10);
    assign next_state[3] = (next_state_enc == 2'b11);

    // Output remains simple
    assign out = state[3];

endmodule
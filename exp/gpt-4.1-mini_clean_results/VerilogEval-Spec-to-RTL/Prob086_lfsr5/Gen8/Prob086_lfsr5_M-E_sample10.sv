module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    wire feedback;
    wire [4:0] next_q;

    // feedback is the LSB of the current state
    assign feedback = q[0];

    // Compute next state with taps at bit 4 and bit 2 (positions 5 and 3)
    assign next_q[4] = q[4] ^ feedback;  // tap at bit 5
    assign next_q[3] = q[3];              // no tap, just shift
    assign next_q[2] = q[2] ^ feedback;  // tap at bit 3
    assign next_q[1] = q[1];              // no tap, just shift
    assign next_q[0] = q[0];              // will be shifted in from q[1] below

    // Shift right operation (effectively moving bits down one position)
    // next_q bits have taps applied; now perform shift right
    // Correctly, the new q[0] comes from old q[1], q[1] from old q[2], etc.
    // So the above assignments define tapped bits before shifting,
    // we need to implement the right-shift with taps accordingly:

    // To correctly implement the Galois LFSR shift right, the next state bits are:
    // q_next[4] <= feedback XOR q[4]
    // q_next[3] <= q[4]
    // q_next[2] <= feedback XOR q[2]
    // q_next[1] <= q[2]
    // q_next[0] <= q[1]

    // Let's fix next_q with this logic using a combinational block:

    reg [4:0] computed_next_q;

    always @(*) begin
        computed_next_q[4] = feedback ^ q[4]; // tap at bit 5
        computed_next_q[3] = q[4];
        computed_next_q[2] = feedback ^ q[2]; // tap at bit 3
        computed_next_q[1] = q[2];
        computed_next_q[0] = q[1];
    end

    always @(posedge clk) begin
        if (reset)
            q <= 5'b00001;  // synchronous reset to 1
        else
            q <= computed_next_q;
    end

endmodule
module TopModule (
    input        in,
    input  [1:0] state,
    output [1:0] next_state,
    output       out
);

    // Define next_state for input=0 for states A-D respectively
    localparam [1:0] NEXT_STATE_0 [0:3] = {2'b00, 2'b10, 2'b00, 2'b10};
    // Define next_state for input=1 for states A-D respectively
    localparam [1:0] NEXT_STATE_1 [0:3] = {2'b01, 2'b01, 2'b11, 2'b01};
    // Define output for states A-D respectively
    localparam        OUT_STATE    [0:3] = {1'b0, 1'b0, 1'b0, 1'b1};

    assign next_state = in ? NEXT_STATE_1[state] : NEXT_STATE_0[state];
    assign out        = OUT_STATE[state];

endmodule
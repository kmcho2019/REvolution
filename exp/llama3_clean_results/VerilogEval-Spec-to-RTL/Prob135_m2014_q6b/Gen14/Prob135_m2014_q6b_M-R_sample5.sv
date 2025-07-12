module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

    assign Y1 = y[1];

    wire next_y0, next_y1, next_y2;

    assign next_y0 = (~y[2] & ~y[1] & ~y[0] & ~w) | 
                     (~y[2] & ~y[1] & y[0] & ~w) | 
                     (~y[2] & y[1] & y[0] & w) | 
                     (y[2] & y[1] & y[0] & ~w);

    assign next_y1 = (~y[2] & ~y[1] & ~y[0] & w) | 
                     (~y[2] & y[1] & ~y[0] & ~w) | 
                     (~y[2] & y[1] & y[0] & ~w) | 
                     (y[2] & ~y[1] & y[0] & w);

    assign next_y2 = (y[2] & ~y[1] & ~y[0] & w) | 
                     (~y[2] & y[1] & ~y[0] & w) | 
                     (~y[2] & ~y[1] & y[0] & w) | 
                     (y[2] & y[1] & y[0] & w);

    // assuming a flip-flop is used to store the state
    // the next state logic is computed above
    // and can be assigned to the output of the flip-flop
    // for example:
    // reg [2:0] state;
    // always @(posedge clk) state <= {next_y2, next_y1, next_y0};

endmodule
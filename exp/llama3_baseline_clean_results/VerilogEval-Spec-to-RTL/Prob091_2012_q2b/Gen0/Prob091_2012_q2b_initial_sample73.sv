module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    assign Y1 = (y[0] && w) || // State A to State B
                (y[1] && w) || // State B to State C (then C can go to E)
                (y[1] && ~w) || // State B to State D
                (y[2] && w) || // State C to State E
                (y[2] && ~w) || // State C to State D
                (y[4] && ~w) || // State E to State D
                (y[5] && ~w); // State F to State D

    assign Y3 = (y[1] && ~w) || // State B to State D
                (y[2] && ~w) || // State C to State D
                (y[3]) ||      // State D stays in State D when w=0 and comes from other states
                (y[4] && ~w) || // State E to State D
                (y[5] && ~w);  // State F to State D

endmodule
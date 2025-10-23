module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Y1 is high when the current state is B
assign Y1 = (y[1] && w) || 
            (y[5] && w) || 
            (y[0] && ~w && y[4]);

// Y3 is high when the current state is D
assign Y3 = (y[3] && w) || 
            (y[3] && ~w) || 
            (y[0] && w && ~y[4]) || 
            (y[1] && ~w) || 
            (y[2] && ~w) || 
            (y[4] && ~w);

endmodule
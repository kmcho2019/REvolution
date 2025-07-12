module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded state signals
wire stateA = y[0];
wire stateB = y[1];
wire stateC = y[2];
wire stateD = y[3];
wire stateE = y[4];
wire stateF = y[5];

// Next-state logic for Y1 (y[1])
assign Y1 = (stateA && w) || (stateB && ~w);

// Next-state logic for Y3 (y[3])
assign Y3 = (~w && (stateB || stateC || stateE)) || (w && stateF);

endmodule
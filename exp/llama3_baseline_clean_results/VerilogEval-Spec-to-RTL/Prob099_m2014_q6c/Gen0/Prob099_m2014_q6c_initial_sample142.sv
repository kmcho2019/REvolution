module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state signal Y2 (y[1]) corresponds to state B
assign Y2 = ~w & y[0];  // A (000001) -> B when w = 0

// Next-state signal Y4 (y[3]) corresponds to state D
assign Y4 = (~w & y[1]) | (~w & y[2]) | (w & y[4]) | (w & y[5]);  
// B (000010) -> D when w = 0, C (000100) -> D when w = 0, E (010000) -> D when w = 1, F (100000) -> D when w = 1

// Output signals
assign Y1 = y[0];  // State A
assign Y3 = y[2];  // State C

endmodule
module TopModule (
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Y1 is next-state input for y[1], active when state A (y[0]) and input w=1
    Y1 = y[0] & w;
    // Y3 is next-state input for y[3], active when any of states B, C, E, or F are active and w=0
    Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w;
end

endmodule
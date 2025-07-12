module TopModule(
    input  [5:0] y,
    input        w,
    output reg   Y1,
    output reg   Y3
);

always @(*) begin
    // Invert input w
    wire w_n = ~w;
    
    // Next state input for y[1] (state B)
    Y1 = y[0] & w;
    
    // Next state input for y[3] (state D)
    Y3 = w_n & (y[1] | y[2] | y[4] | y[5]);
end

endmodule
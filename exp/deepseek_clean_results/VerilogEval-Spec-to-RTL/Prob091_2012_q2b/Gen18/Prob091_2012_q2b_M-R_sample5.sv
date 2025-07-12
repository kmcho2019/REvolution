module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        // Next state logic for y[1] (B state)
        Y1 = y[0] & w;
        
        // Next state logic for y[3] (D state)
        Y3 = ~w & ~(y[0] | y[3]);
    end

endmodule
module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    always @(*)
    begin
        // Initialize outputs to 0, assuming no transition by default
        Y1 = 1'b0;
        Y3 = 1'b0;

        // State A (000001) to B (000010) transition based on input w
        if (y[0] & w) Y1 = 1'b1;

        // Transition to state D (001000) from various states based on input w and current state
        if (~w & (y[1] | y[2] | y[4] | y[5])) Y3 = 1'b1;
    end

endmodule
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

        // Simplify the transition logic by directly checking the relevant states
        // and input condition for each output
        if (y[0] && w) begin // Transition from A to B
            Y1 = 1'b1;
        end else if ((y[2] && w) || (y[4] && ~w) || (y[5] && ~w) || (y[1] && ~w)) begin // Transition to D from C, E, F, or B
            Y3 = 1'b1;
        end
    end

endmodule
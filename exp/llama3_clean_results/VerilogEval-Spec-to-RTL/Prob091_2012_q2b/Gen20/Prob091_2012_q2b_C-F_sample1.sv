module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Directly assign next state for Y1 (State B) based on current state and input w
    always @(*) begin
        Y1 = w & y[0];
    end

    // Assign next state for Y3 (State D) considering all possible transitions to State D
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule
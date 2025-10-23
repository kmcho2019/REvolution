module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Direct implementation of Y1 logic
    always @(*) begin
        Y1 = w & y[0];
    end

    // Direct implementation of Y3 logic
    always @(*) begin
        Y3 = ~w & (y[1] | y[2] | y[4] | y[5]);
    end

endmodule
module TopModule(
    input  [5:0] y,
    input  w,
    output reg Y1,
    output reg Y3
);

    // Calculate Y1 (state B) directly
    always @(*) begin
        Y1 = y[0] && w;
    end

    // Calculate Y3 (state D) directly
    always @(*) begin
        Y3 = ~w && (y[1] || y[2] || y[4] || y[5]);
    end

endmodule
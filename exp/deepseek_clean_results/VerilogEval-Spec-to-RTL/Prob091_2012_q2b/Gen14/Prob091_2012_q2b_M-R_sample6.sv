module TopModule (
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

    always @(*) begin
        // Same logic as original but in procedural block
        Y1 = y[0] & w;
        Y3 = ~w & ~(y[0] | y[3]);
    end

endmodule
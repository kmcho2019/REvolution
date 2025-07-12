module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @ (posedge clk) begin
        state <= ~(a & b) & ~state | ~a & ~b & state;
    end

    always @ (*) begin
        q = (~a & b) | (a & ~b) | (state & a & b);
    end

endmodule
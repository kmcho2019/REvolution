module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    always @(posedge clk) begin
        state <= ~a & ~b | a & ~b & state | ~a & b & state;
    end
    
    assign q = b ? state : (a & state) | (a & ~state & ~b);

endmodule
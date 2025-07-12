module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    always @(posedge clk) begin
        state <= b;
    end

    assign q = state & ~a;

endmodule
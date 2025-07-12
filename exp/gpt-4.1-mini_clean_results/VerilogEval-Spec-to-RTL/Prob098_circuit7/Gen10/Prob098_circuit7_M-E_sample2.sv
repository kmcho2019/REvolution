module TopModule (
    input clk,
    input a,
    output reg q
);
    reg a_delayed;

    always @(posedge clk) begin
        a_delayed <= a;
        q <= q ^ a_delayed;
    end
endmodule
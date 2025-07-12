module TopModule (
    input clk,
    input a,
    output reg q
);
    reg dff_q;
    always @(posedge clk) begin
        dff_q <= a;
    end
    always @(*) begin
        q = ~dff_q;
    end
endmodule
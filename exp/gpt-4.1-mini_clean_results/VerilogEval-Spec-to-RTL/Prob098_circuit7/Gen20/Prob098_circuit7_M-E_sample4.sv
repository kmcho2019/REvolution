module TopModule (
    input clk,
    input a,
    output reg q
);
    // On every rising edge of clk, capture inverted 'a'
    always @(posedge clk) begin
        q <= ~a;
    end
endmodule
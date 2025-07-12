module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Invert 'a' inline during DFF capture
    end
endmodule
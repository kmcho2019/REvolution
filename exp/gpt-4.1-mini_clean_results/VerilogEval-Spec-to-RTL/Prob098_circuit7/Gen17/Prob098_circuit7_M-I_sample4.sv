module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Sample the inverted input directly in the flip-flop
    end
endmodule
module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Capture inverted input at clock edge
    end
endmodule
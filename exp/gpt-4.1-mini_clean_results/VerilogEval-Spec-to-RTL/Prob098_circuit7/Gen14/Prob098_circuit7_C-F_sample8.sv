module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // Capture the inverted 'a' synchronously on rising clock edge
    end
endmodule
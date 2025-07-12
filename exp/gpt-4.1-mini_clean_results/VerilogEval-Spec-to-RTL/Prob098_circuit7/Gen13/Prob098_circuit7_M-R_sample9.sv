module TopModule (
    input clk,
    input a,
    output reg q
);
    always @(posedge clk) begin
        q <= ~a;  // invert 'a' at clock edge and store in q
    end
endmodule
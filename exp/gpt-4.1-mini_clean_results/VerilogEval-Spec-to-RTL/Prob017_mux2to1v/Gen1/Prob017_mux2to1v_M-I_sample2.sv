module TopModule (
    input              clk,
    input      [99:0]  a,
    input      [99:0]  b,
    input              sel,
    output reg [99:0]  out
);
    always @(posedge clk) begin
        out <= sel ? b : a;
    end
endmodule
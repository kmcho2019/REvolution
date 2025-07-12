module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

always @(posedge clk) begin
    Q <= (j ^ k) ? j : (j ^ Q);
end

endmodule
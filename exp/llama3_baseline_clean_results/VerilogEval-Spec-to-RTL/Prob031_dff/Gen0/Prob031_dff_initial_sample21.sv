module TopModule(
    input clk,
    input d,
    input q, // Not used in the implementation
    output reg out
);

always @(posedge clk) begin
    out <= d;
end

endmodule
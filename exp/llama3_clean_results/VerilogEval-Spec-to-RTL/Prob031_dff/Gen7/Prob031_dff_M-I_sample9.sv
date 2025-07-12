module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d; // Directly update q on the positive edge of clk
end

endmodule
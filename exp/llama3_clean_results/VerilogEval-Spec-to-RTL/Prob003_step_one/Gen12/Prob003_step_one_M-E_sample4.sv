module TopModule (
    output one,
    input clk // Assuming a global clock signal
);

always @(posedge clk) begin
    one <= 1'b1;
end

endmodule
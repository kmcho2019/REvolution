module TopModule (
    output reg one,
    input clk // Assuming a clock input for the sequential logic
);

always @ (posedge clk) begin
    one <= 1'b1;
end

initial begin
    one = 1'b1;
end

endmodule
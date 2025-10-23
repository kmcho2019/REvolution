module TopModule(
    input clk,
    input d,
    output reg q = 1'b0 // Initialize q with a default value
);

always @(posedge clk) begin
    q <= d;
end

endmodule
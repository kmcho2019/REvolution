module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

// Explicitly initialize q for clarity and ensuring defined behavior at startup
initial q = 1'b0;

endmodule
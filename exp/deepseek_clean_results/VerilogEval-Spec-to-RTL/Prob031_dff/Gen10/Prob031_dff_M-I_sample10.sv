module TopModule (
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

// Note: For production use, consider adding asynchronous reset:
// always @(posedge clk or posedge reset) begin
//     if (reset) q <= 1'b0;
//     else q <= d;
// end

endmodule
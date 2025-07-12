module TopModule (
    input clk,
    input a,
    output reg q
);

wire inverted_a;
assign inverted_a = ~a;

always @(posedge clk) begin
    q <= inverted_a;  // Register the inverted value
end

endmodule
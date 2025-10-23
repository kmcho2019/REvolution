module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] binary_count;

always @(posedge clk) begin
    if (reset) begin
        binary_count <= 1;
    end else if (binary_count == 10) begin
        binary_count <= 1;
    end else begin
        binary_count <= binary_count + 1;
    end
end

assign q = binary_count;

endmodule
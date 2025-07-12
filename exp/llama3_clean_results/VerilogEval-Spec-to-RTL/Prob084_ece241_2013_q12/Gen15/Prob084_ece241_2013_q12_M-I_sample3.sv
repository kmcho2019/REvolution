module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S}; // Directly shift the bits
    end
end

always @(*) begin
    Z = Q[{A, B, C}]; // Use concatenation to select the bit
end

endmodule
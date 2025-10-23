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

// Use a more traditional decoder and multiplexer structure
always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
    end
end

// Use a more power-efficient multiplexer architecture
always @(*) begin
    Z = Q[{A, B, C}];
end

endmodule
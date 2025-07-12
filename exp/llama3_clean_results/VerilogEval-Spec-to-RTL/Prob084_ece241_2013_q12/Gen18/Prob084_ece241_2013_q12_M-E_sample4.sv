module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] LUT;

integer i;

initial begin
    for (i = 0; i < 8; i++) begin
        LUT[i] = 1'b0;
    end
end

always @(posedge clk) begin
    if (enable) begin
        LUT[7:1] = LUT[6:0];
        LUT[0] = S;
    end
end

assign Z = LUT[{A, B, C}];

endmodule
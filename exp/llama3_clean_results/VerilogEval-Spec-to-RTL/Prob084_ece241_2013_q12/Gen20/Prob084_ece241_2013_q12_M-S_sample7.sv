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

always @(posedge clk) begin
    if (enable) begin
        LUT <= {LUT[6:0], S};
    end
end

assign Z = LUT[{A, B, C}];

endmodule
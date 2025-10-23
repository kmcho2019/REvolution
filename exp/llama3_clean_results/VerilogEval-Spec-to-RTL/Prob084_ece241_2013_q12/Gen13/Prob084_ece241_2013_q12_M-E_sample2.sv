module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] memory;

always @(posedge clk) begin
    if (enable) begin
        memory[{A, B, C}] <= S;
    end
end

always @(*) begin
    Z = memory[{A, B, C}];
end

endmodule
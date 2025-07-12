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
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

wire [2:0] addr = {A, B, C};
reg [7:0] out;

always @(*) begin
    out = 8'b00000000;
    out[addr] = 1'b1;
end

always @(posedge clk) begin
    Z <= Q[addr];
end

endmodule
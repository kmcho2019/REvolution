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
        Q <= {S, Q[7:1]};
    end else begin
        Q <= Q;
    end
end

always @(*) begin
    Z = Q[{A, B, C}];
end

endmodule
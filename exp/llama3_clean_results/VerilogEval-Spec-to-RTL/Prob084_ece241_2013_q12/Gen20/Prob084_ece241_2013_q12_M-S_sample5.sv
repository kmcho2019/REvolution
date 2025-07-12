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
        Q[0] <= S;
        for (int i = 1; i < 8; i++) begin
            Q[i] <= Q[i-1];
        end
    end
end

assign Z = Q[{A, B, C}];

endmodule
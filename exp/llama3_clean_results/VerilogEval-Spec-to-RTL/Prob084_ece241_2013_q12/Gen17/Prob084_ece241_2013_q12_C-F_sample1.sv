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
        for (int i = 7; i > 0; i--) begin
            Q[i] <= Q[i-1];
        end
        Q[0] <= S;
    end
end

assign Z = Q[{A, B, C}];

endmodule
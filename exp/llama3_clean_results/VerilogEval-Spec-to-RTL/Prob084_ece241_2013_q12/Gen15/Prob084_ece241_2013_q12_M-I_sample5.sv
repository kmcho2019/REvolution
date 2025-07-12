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

// Implement clock gating for power optimization
reg gated_clk;
always @(posedge clk or negedge enable) begin
    if (!enable) begin
        gated_clk <= 0;
    end else begin
        gated_clk <= 1;
    end
end

always @(posedge gated_clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

always @(*) begin
    Z = Q[{A, B, C}];
end

endmodule
module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

// Apply clock gating to reduce power consumption
wire clk_gated = clk && enable;

always @(posedge clk_gated) begin
    Q[7:1] <= Q[6:0];
    Q[0] <= S;
end

// Use a more efficient 3-to-8 decoder and multiplexer design
wire [7:0] one_hot = 8'b1 << ({A, B, C});
assign Z = (one_hot & Q);

endmodule
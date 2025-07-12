module TopModule (
    input clk,
    input j,
    input k,
    output reg Q
);

wire update_en = j | k;  // Enable clock only if an update is required
wire gated_clk;

assign gated_clk = clk & update_en;

wire Qnext = (j & ~Q) | (~k & Q);

always @(posedge gated_clk) begin
    Q <= Qnext;
end

endmodule
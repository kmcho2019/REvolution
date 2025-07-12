module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

wire gated_clk;
reg reset_sync;

// Clock gating for reset path
assign gated_clk = reset ? 1'b0 : clk;

always @(posedge clk) begin
    reset_sync <= reset;
end

always @(posedge gated_clk or posedge reset_sync) begin
    if (reset_sync) begin
        q <= 8'b0;
    end
    else begin
        q <= d;
    end
end

endmodule
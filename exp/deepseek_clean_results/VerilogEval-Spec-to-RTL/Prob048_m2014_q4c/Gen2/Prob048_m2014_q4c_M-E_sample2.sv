module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire gated_clk;
reg update_en;

// Generate update enable signal
always @* begin
    update_en = r || (d != q);
end

// Clock gating logic
assign gated_clk = clk & update_en;

// Flip-flop behavior
always @(posedge gated_clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule
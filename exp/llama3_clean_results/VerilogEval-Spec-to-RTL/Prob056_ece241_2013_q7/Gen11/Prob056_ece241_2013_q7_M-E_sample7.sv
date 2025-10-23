module TopModule(
    input clk,
    input j,
    input k,
    output reg Q
);

wire hold;
wire reset;
wire set;
wire toggle;

assign hold = ~j & ~k;
assign reset = ~j & k;
assign set = j & ~k;
assign toggle = j & k;

always @(posedge clk) begin
    if (reset) begin
        Q <= 1'b0;
    end else if (set) begin
        Q <= 1'b1;
    end else if (toggle) begin
        Q <= ~Q;
    end else if (hold) begin
        // No change
    end
end

endmodule
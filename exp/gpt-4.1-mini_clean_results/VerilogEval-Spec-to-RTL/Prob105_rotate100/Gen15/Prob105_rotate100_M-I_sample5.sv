module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

// Generate clock enable: update q only if loading or rotating (ena==01 or ena==10)
wire clk_en = load | (ena == 2'b01) | (ena == 2'b10);

always @(posedge clk) begin
    if (clk_en) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: q <= {q[0], q[99:1]};  // rotate right
                2'b10: q <= {q[98:0], q[99]}; // rotate left
                default: q <= q;               // no change, but should not happen due to clk_en gating
            endcase
        end
    end
end

endmodule
module TopModule (
    input          clk,
    input          load,
    input   [1:0]  ena,
    input   [99:0] data,
    output  reg [99:0] q
);

wire write_enable = load | (ena == 2'b01) | (ena == 2'b10);

always @(posedge clk) begin
    if (write_enable) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: q <= {q[0], q[99:1]};  // Rotate right by 1 bit
                2'b10: q <= {q[98:0], q[99]}; // Rotate left by 1 bit
                default: q <= q;               // Should not occur due to write_enable gating
            endcase
        end
    end
    // else retain q without toggling, reducing power consumption
end

endmodule
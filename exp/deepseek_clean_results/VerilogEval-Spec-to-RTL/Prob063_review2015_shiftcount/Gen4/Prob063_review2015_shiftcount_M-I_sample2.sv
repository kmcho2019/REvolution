module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire clk_enable = shift_ena | count_ena;
wire gated_clk = clk & clk_enable;

always @(posedge gated_clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[2:0], data};       // Shift operation
        2'b01: q <= q - 1'b1;             // Count operation
        default: q <= q;                  // Hold value (explicit)
    endcase
end

endmodule
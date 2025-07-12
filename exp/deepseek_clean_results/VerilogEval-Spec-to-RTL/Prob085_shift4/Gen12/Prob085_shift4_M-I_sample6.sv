module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q
);

reg gated_clk;
always @(*) begin
    gated_clk = clk & (ena | load);
end

always @(posedge gated_clk or posedge areset) begin
    case ({areset, load, ena})
        3'b100,
        3'b101,
        3'b110,
        3'b111: q <= 4'b0;  // Reset has highest priority
        3'b010,
        3'b011: q <= data;  // Load has next priority
        3'b001: q <= {1'b0, q[3:1]};  // Shift right with zero fill
        default: q <= q;    // Hold value
    endcase
end

endmodule
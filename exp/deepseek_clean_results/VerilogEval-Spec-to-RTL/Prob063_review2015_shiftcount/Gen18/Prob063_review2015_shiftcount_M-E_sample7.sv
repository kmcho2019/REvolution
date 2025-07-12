module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] shifted_val = {q[2:0], data};
wire [3:0] counted_val = q - 1'b1;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= shifted_val;    // Shift operation
        2'b01: q <= counted_val;    // Count operation
        default: q <= q;            // Maintain value
    endcase
end

endmodule
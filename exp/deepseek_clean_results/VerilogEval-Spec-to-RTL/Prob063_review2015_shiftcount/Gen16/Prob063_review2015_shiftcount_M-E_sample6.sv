module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [3:0] shift_val = {q[2:0], data};
wire [3:0] count_val = q - 1'b1;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10, 2'b11: q <= shift_val;  // Shift has priority when both are set
        2'b01:        q <= count_val;  // Count when only count_ena is set
        default:      q <= q;         // Hold value when neither is set
    endcase
end

endmodule
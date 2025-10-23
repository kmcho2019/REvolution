module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {q[2:0], data};  // Shift has priority if both
        2'b01: q <= q - 1'b1;        // Count when only count_ena
        default: q <= q;              // Hold state otherwise
    endcase
end

endmodule
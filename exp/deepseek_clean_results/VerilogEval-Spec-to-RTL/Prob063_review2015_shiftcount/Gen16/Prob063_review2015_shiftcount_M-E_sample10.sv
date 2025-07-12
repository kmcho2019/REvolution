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
        2'b10: q <= shift_val;    // Shift has priority
        2'b01: q <= count_val;    // Count when no shift
        default: q <= q;          // Hold value otherwise
    endcase
end

endmodule
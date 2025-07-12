module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Parallel computation of both possible operations
wire [3:0] shift_result = {q[2:0], data};
wire [3:0] count_result = q - 1'b1;

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= shift_result;    // Shift operation
        2'b01: q <= count_result;    // Count operation
        default: q <= q;            // Maintain current value
    endcase
end

endmodule
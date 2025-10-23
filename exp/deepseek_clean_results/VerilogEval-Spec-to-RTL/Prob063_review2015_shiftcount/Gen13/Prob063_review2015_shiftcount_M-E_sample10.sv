module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= {data, q[3:1]};  // Shift operation (rotate right with data input)
        2'b01: q <= q - 1'b1;        // Count operation
        default: q <= q;              // Hold current value
    endcase
end

endmodule
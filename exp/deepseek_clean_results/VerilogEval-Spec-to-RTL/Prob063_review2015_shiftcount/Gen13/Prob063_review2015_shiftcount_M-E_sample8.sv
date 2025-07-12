module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

wire [1:0] op_sel = {shift_ena, count_ena};
wire [3:0] shift_val = {q[2:0], data};
wire [3:0] count_val = q - 1'b1;

always @(posedge clk) begin
    case (op_sel)
        2'b10: q <= shift_val;    // Shift operation
        2'b01: q <= count_val;    // Count operation
        default: q <= q;          // No operation (hold)
    endcase
end

endmodule
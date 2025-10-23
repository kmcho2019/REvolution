module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [1:0] op_state; // 00: idle, 01: count, 10: shift

always @(posedge clk) begin
    // State update logic
    if (shift_ena)
        op_state <= 2'b10;
    else if (count_ena)
        op_state <= 2'b01;
    else
        op_state <= 2'b00;

    // Operation execution
    case (op_state)
        2'b10: q <= {q[2:0], data};  // Shift operation
        2'b01: q <= q - 1'b1;        // Count operation
        default: q <= q;             // Hold state
    endcase
end

endmodule
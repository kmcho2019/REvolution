module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Internal signals
wire [1:0] op_sel;
wire [3:0] next_count;
wire [3:0] next_shift;

// Operation selection logic (priority: shift > count > hold)
assign op_sel = shift_ena ? 2'b01 : 
                count_ena ? 2'b10 : 
                2'b00;

// Next state computation (parallel paths)
assign next_shift = {q[2:0], data};  // Shift operation
assign next_count = q - 1'b1;        // Count operation

always @(posedge clk) begin
    case(op_sel)
        2'b01: q <= next_shift;  // Shift
        2'b10: q <= next_count;  // Count
        default: q <= q;         // Hold
    endcase
end

endmodule
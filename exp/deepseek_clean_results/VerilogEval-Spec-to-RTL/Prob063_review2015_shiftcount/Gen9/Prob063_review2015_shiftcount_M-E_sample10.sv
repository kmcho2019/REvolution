module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Next state computation in parallel
wire [3:0] next_shift = {q[2:0], data};  // Shift operation
wire [3:0] next_count = q - 1'b1;        // Count operation

// Operation selection
always @(posedge clk) begin
    case ({shift_ena, count_ena})
        2'b10: q <= next_shift;   // Shift has priority
        2'b01: q <= next_count;   // Count operation
        default: q <= q;          // Hold state
    endcase
end

endmodule
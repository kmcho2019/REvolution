module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

reg [3:0] next_q;

// Combinational next-state logic
always_comb begin
    case ({shift_ena, count_ena})
        2'b10: next_q = {q[2:0], data};  // Shift operation
        2'b01: next_q = q - 1'b1;        // Count operation
        default: next_q = q;              // Hold state
    endcase
end

// Sequential element (flip-flop)
always_ff @(posedge clk) begin
    q <= next_q;
end

endmodule
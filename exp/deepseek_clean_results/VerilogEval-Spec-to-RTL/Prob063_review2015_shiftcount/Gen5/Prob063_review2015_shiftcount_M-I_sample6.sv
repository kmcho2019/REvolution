module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Operation selection registered to break timing path
reg op_shift, op_count;
always @(posedge clk) begin
    op_shift <= shift_ena;
    op_count <= count_ena;
end

// Parallel computation paths
wire [3:0] shift_val = {q[2:0], data};
wire [3:0] count_val = q ^ 4'b1111 + {3'b0, count_ena}; // Invert and add 1 when counting

// Clock gating with latch-based approach
reg gated_clk;
always @(*) begin
    if (~clk) gated_clk = shift_ena | count_ena;
end

// Registered update with optimized mux
always @(posedge clk) begin
    if (gated_clk) begin
        case ({op_shift, op_count})
            2'b10: q <= shift_val;    // Shift operation
            2'b01: q <= count_val;    // Count operation
            default: q <= q;          // No operation
        endcase
    end
end

endmodule
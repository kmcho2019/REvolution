module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Separate paths for better timing
wire [3:0] shift_q = {q[2:0], data};
wire [3:0] count_q = q ^ 4'b1111 + {3'b0, count_ena}; // Optimized decrement

// Operation selection with registered control
reg op_shift, op_count;
always @(posedge clk) begin
    op_shift <= shift_ena;
    op_count <= count_ena;
end

// Clock gating with separate enables
always @(posedge clk) begin
    if (op_shift) begin
        q <= shift_q;
    end
    else if (op_count) begin
        q <= count_q;
    end
    // Else maintain current value
end

endmodule
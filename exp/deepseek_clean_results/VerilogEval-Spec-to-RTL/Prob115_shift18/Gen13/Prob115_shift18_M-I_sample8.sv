module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] next_q;
wire do_shift = ena & ~load;
wire shift_right = amount[1];
wire [3:0] shift_amount = amount[0] ? 3'd7 : 3'd0; // 8 or 1 bit shift

// Shift computation (only when enabled)
always @(*) begin
    if (load) begin
        next_q = data;
    end
    else if (ena) begin
        case ({shift_right, shift_amount})
            4'b0_000: next_q = {q[62:0], 1'b0};        // Left 1
            4'b0_111: next_q = {q[55:0], 8'b0};        // Left 8
            4'b1_000: next_q = q >>> 1;                // Right 1 (arithmetic)
            4'b1_111: next_q = q >>> 8;                // Right 8 (arithmetic)
            default:  next_q = q;
        endcase
    end
    else begin
        next_q = q;
    end
end

// Register update with clock gating
always @(posedge clk) begin
    if (load || ena) begin
        q <= next_q;
    end
end

endmodule
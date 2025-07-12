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
wire [1:0] shift_ctrl = {ena, load};

// Shift computation (only when ena is active)
always @(*) begin
    if (ena) begin
        case (amount)
            2'b00: next_q = {q[62:0], 1'b0};          // Left 1
            2'b01: next_q = {q[55:0], 8'b0};          // Left 8
            2'b10: next_q = $signed(q) >>> 1;         // Right 1 (arithmetic)
            2'b11: next_q = $signed(q) >>> 8;         // Right 8 (arithmetic)
        endcase
    end
    else begin
        next_q = q; // Hold value when not enabled
    end
end

// Efficient register update with priority to load
always @(posedge clk) begin
    case (shift_ctrl)
        2'b01, 2'b11: q <= data;      // Load has priority
        2'b10:        q <= next_q;    // Shift when ena=1, load=0
        default:      q <= q;         // Hold state
    endcase
end

endmodule
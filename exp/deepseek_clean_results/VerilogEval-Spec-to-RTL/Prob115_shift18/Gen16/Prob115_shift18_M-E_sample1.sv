module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Sign extension masks
wire [63:0] sign_mask_1 = {64{q[63]}};
wire [63:0] sign_mask_8 = {{8{q[63]}}, {56{1'b0}}};

// Pre-compute all shift options (power-gated by ena)
wire [63:0] shift_left_1  = ena ? (q << 1) : q;
wire [63:0] shift_left_8  = ena ? (q << 8) : q;
wire [63:0] shift_right_1 = ena ? ((q >> 1) | (sign_mask_1 & {q[63], {63{1'b0}}})) : q;
wire [63:0] shift_right_8 = ena ? ((q >> 8) | sign_mask_8) : q;

// Shift selection multiplexer
reg [63:0] shifted_val;
always @(*) begin
    case (amount)
        2'b00: shifted_val = shift_left_1;
        2'b01: shifted_val = shift_left_8;
        2'b10: shifted_val = shift_right_1;
        2'b11: shifted_val = shift_right_8;
        default: shifted_val = q;
    endcase
end

// Final output selection (load has priority)
wire [63:0] next_q = load ? data : shifted_val;

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule
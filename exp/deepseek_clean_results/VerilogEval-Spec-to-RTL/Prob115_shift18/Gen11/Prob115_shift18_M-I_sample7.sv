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

// Parallel shift computation
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = $signed(q) >>> 1;
wire [63:0] shift_right_8 = $signed(q) >>> 8;

// Shift selection using case statement
always @(*) begin
    if (do_shift) begin
        case (amount)
            2'b00: next_q = shift_left_1;
            2'b01: next_q = shift_left_8;
            2'b10: next_q = shift_right_1;
            2'b11: next_q = shift_right_8;
            default: next_q = q;
        endcase
    end
    else begin
        next_q = q; // Hold value when not shifting
    end
end

// Clock-gated update logic
always @(posedge clk) begin
    if (load)
        q <= data;
    else if (ena)
        q <= next_q;
    // else retain value (implicit)
end

endmodule
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Compute sign bit only when needed for right shifts
wire sign_bit = q[63] & (amount[1] & ena);

// Pre-compute all shift options in parallel
wire [63:0] shift_left_1  = {q[62:0], 1'b0};
wire [63:0] shift_left_8  = {q[55:0], 8'b0};
wire [63:0] shift_right_1 = {sign_bit, q[63:1]};
wire [63:0] shift_right_8 = {{8{sign_bit}}, q[63:8]};

// Enable-gated shift selection with balanced case
reg [63:0] next_q;
always @(*) begin
    if (!ena) begin
        next_q = q;
    end else begin
        case (amount)
            2'b00: next_q = shift_left_1;
            2'b01: next_q = shift_left_8;
            2'b10: next_q = shift_right_1;
            2'b11: next_q = shift_right_8;
            default: next_q = q;
        endcase
    end
end

// Synchronous update with load priority
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule
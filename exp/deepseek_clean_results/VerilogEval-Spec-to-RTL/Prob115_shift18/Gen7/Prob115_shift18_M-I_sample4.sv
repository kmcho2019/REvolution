module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

reg [63:0] next_q;
wire [63:0] shift_left_1, shift_left_8, shift_right_1, shift_right_8;
wire [63:0] selected_shift;

// Compute all shift possibilities in parallel
assign shift_left_1 = {q[62:0], 1'b0};
assign shift_left_8 = {q[55:0], 8'b0};
assign shift_right_1 = {q[63], q[63:1]};
assign shift_right_8 = {{8{q[63]}}, q[63:8]};

// Select the appropriate shift based on amount
assign selected_shift = (amount == 2'b00) ? shift_left_1 :
                       (amount == 2'b01) ? shift_left_8 :
                       (amount == 2'b10) ? shift_right_1 :
                       shift_right_8;

// Only shift when enabled, otherwise maintain current value
wire [63:0] shifted_value = ena ? selected_shift : q;

// Load has priority over shift
always @(*) begin
    next_q = load ? data : shifted_value;
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule
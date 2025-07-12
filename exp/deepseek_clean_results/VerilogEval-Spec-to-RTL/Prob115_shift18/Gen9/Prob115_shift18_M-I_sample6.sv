module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Registered shift control signals
reg shift_right_reg, shift_8_reg;
always @(posedge clk) begin
    shift_right_reg <= amount[1];
    shift_8_reg <= amount[0];
end

// Pre-compute sign extension when needed
wire sign_bit = q[63];
reg [7:0] sign_ext;
always @(*) begin
    if (shift_right_reg)
        sign_ext = {8{sign_bit}};
    else
        sign_ext = 8'b0; // Don't care for left shifts
end

// Shift computation (activated only when ena is high)
wire [63:0] shifted_value;
assign shifted_value = (ena) ? 
    (shift_right_reg ? 
        (shift_8_reg ? {sign_ext, q[63:8]} :  // Right 8 (arithmetic)
                      {sign_bit, q[63:1]}) :  // Right 1 (arithmetic)
        (shift_8_reg ? {q[55:0], 8'b0} :     // Left 8
                      {q[62:0], 1'b0})        // Left 1
    : q;

// Priority: load over shift
wire [63:0] next_q = load ? data : shifted_value;

always @(posedge clk) begin
    q <= next_q;
end

endmodule
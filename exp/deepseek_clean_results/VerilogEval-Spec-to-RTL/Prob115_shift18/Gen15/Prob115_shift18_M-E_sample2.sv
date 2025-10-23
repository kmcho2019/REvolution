module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Internal signals
reg [63:0] shift_reg;
wire [63:0] shifted_value;

// Pre-compute all shift patterns
wire [63:0] left_shift_1 = {q[62:0], 1'b0};
wire [63:0] left_shift_8 = {q[55:0], 8'b0};
wire [63:0] right_shift_1 = {q[63], q[63:1]};  // Arithmetic right shift
wire [63:0] right_shift_8 = {{8{q[63]}}, q[63:8]};  // Arithmetic right shift

// Shift selection multiplexer
assign shifted_value = (amount == 2'b00) ? left_shift_1 :
                      (amount == 2'b01) ? left_shift_8 :
                      (amount == 2'b10) ? right_shift_1 :
                      right_shift_8;

// Update logic
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end
    else if (ena) begin
        q <= shifted_value;
    end
    // else q maintains its value
end

endmodule
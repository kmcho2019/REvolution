module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Pre-computed shift masks
parameter [63:0] LEFT_1_MASK  = 64'hFFFFFFFFFFFFFFFE;
parameter [63:0] LEFT_8_MASK  = 64'hFFFFFFFFFFFFFF00;
parameter [63:0] RIGHT_1_MASK = 64'h7FFFFFFFFFFFFFFF;
parameter [63:0] RIGHT_8_MASK = 64'h00FFFFFFFFFFFFFF;

// Shift pattern generator
wire [63:0] shift_pattern;
assign shift_pattern = 
    (amount == 2'b00) ? LEFT_1_MASK :
    (amount == 2'b01) ? LEFT_8_MASK :
    (amount == 2'b10) ? RIGHT_1_MASK : RIGHT_8_MASK;

// Arithmetic right shift handling
wire [63:0] sign_ext = {64{q[63]}};
wire [63:0] right_shift_fill = 
    (amount[0]) ? {8{sign_ext[7:0]}} : sign_ext;

// Combined shift operation
wire [63:0] shifted_value;
assign shifted_value = 
    amount[1] ? // Right shift
        ((q & shift_pattern) >> (amount[0] ? 8 : 1)) | right_shift_fill :
    // Left shift
        (q & shift_pattern) << (amount[0] ? 8 : 1);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else if (ena) begin
        q <= shifted_value;
    end
end

endmodule
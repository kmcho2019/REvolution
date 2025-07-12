module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

wire [5:0] shift_amount;
wire shift_left;
wire [63:0] shifted_left, shifted_right;
wire [63:0] shifted_result;
wire [63:0] next_q;

// Shift amount decoder
assign shift_amount = (amount == 2'b00) ? 6'd1 :  // Left by 1
                     (amount == 2'b01) ? 6'd8 :  // Left by 8
                     (amount == 2'b10) ? 6'd1 :  // Right by 1
                     6'd8;                       // Right by 8

assign shift_left = (amount[1] == 1'b0);  // 00 or 01 means left shift

// Barrel shifter - left shift version
assign shifted_left = q << shift_amount;

// Barrel shifter - right shift version with sign extension
assign shifted_right = ({{64{q[63]}}} << (6'd64 - shift_amount)) | (q >> shift_amount);

// Select left or right shift result
assign shifted_result = shift_left ? shifted_left : shifted_right;

// Next value logic
assign next_q = load ? data : (ena ? shifted_result : q);

// Register update
always @(posedge clk) begin
    q <= next_q;
end

endmodule
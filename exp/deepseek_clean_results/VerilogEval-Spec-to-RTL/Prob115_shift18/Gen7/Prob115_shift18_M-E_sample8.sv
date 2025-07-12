module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Shift direction and magnitude decoding
wire shift_right = amount[1];
wire shift_8 = amount[0];
wire [5:0] shift_amount = shift_8 ? 6'd8 : 6'd1;

// Sign extension mask for arithmetic right shifts
wire [63:0] sign_mask = {64{q[63]}} & {64{shift_right}};

// Barrel shifter implementation
wire [63:0] shifted_value;
assign shifted_value = shift_right ? 
                      (sign_mask | (q >> shift_amount)) :  // Arithmetic right shift
                      (q << shift_amount);                 // Logical left shift

// Next state logic with enable gating
wire [63:0] next_q = load ? data : (ena ? shifted_value : q);

always @(posedge clk) begin
    q <= next_q;
end

endmodule
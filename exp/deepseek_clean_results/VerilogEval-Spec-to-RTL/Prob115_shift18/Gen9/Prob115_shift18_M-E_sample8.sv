module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

// Control logic
wire shift_en = ena & ~load;
wire shift_right = amount[1];
wire [3:0] shift_amt = {amount[0], 3'b0}; // 0, 8, 0, 8 (from amount)

// Barrel shifter implementation
wire [63:0] shifted_value;
assign shifted_value = shift_right ? 
    // Arithmetic right shift (sign extend)
    ({{64{q[63]}}} >> (64 - shift_amt)) | (q >> shift_amt) :
    // Left shift
    q << shift_amt;

// Byte shift first (0 or 8 bits)
wire [63:0] byte_shifted = shift_en ? shifted_value : q;

// Then single-bit shift if needed
wire [63:0] final_shifted = 
    (shift_en & ~amount[0]) ? 
        (shift_right ? 
            {byte_shifted[63], byte_shifted[63:1]} :  // Right 1
            {byte_shifted[62:0], 1'b0}) :             // Left 1
        byte_shifted;

// Output selection
always @(posedge clk) begin
    q <= load ? data : final_shifted;
end

endmodule
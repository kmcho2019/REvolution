module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

// Concatenate all inputs into one big vector
wire [23:0] combined_data = {data5, data4, data3, data2, data1, data0};

// Calculate the shift amount (sel * 4)
wire [4:0] shift_amount = {sel, 2'b00}; // Multiply by 4

// Shift and select the output
wire [3:0] shifted_out = combined_data >> shift_amount;

// Only output when sel is valid (0-5)
assign out = (sel < 6) ? shifted_out[3:0] : 4'b0;

endmodule
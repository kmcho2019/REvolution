module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Upper 2-bit group encoding
    wire upper_bit1 = in[3];
    wire upper_bit0 = ~in[3] & in[2];
    wire [1:0] upper_pos = {upper_bit1, upper_bit0} ? {upper_bit1, 1'b0} | {1'b0, upper_bit0} : 2'b00;

    // Lower 2-bit group encoding
    wire lower_bit1 = in[1];
    wire lower_bit0 = ~in[1] & in[0];
    wire [1:0] lower_pos = {lower_bit1, lower_bit0} ? {lower_bit1, 1'b0} | {1'b0, lower_bit0} : 2'b00;

    // Final output with priority (upper over lower)
    assign pos = (|in[3:2]) ? upper_pos : 
                 (|in[1:0]) ? (lower_pos | 2'b10) : 
                 2'b00;

endmodule
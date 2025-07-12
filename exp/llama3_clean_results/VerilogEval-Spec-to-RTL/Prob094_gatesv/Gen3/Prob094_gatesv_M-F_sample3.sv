module TopModule(
    input  [3:0] in,
    output [2:0] out_both,
    output reg [3:0] out_any,
    output [3:0] out_different
);

reg [3:0] shifted_left;
reg [3:0] shifted_right;

always @(*) begin
    shifted_left = {in[2:0], in[3]}; // Shift left by one position and wrap around
    shifted_right = {in[0], in[3:1]}; // Shift right by one position and wrap around

    out_both = in[2:0] & shifted_left[2:0];
    out_any[3:1] = in[3:1] | shifted_right[3:1];
    out_any[0] = in[0] | in[3]; // Handle the case for out_any[0] separately
    out_different = in ^ shifted_left;
end

endmodule
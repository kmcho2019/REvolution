module TopModule(
    input  [3:0] in,
    output reg [2:0] out_both,
    output reg [3:0] out_any,
    output reg [3:0] out_different
);

reg [3:0] shifted_left;
reg [3:0] shifted_right;

always @(*) begin
    shifted_left = {in[2:0], in[3]}; // Shift left by one position and wrap around
    shifted_right = {in[0], in[3:1]}; // Shift right by one position and wrap around

    out_both = in[2:0] & shifted_left[2:0];
    out_any[3:1] = in[3:1] | shifted_right[3:1];
    out_any[0] = 1'b0; // Since out_any starts from index 1, we don't need to calculate for index 0
    out_different = in ^ shifted_left;
end

endmodule
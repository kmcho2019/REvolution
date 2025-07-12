module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

reg [3:0] shifted_left;
reg [3:0] shifted_right;

always @(*) begin
    shifted_left = {in[2:0], in[3]}; // Shift left by one position and wrap around
    shifted_right = {in[0], in[3:1]}; // Shift right by one position and wrap around

    out_both[2:0] = in[2:0] & shifted_left[2:0];
    out_both[3] = 1'b0; // Since in[3] has no neighbor to the left

    out_any[1:3] = in[1:3] | shifted_right[1:3];
    out_any[0] = 1'b0; // Since in[0] has no neighbor to the right

    out_different = in ^ shifted_left;
end

endmodule
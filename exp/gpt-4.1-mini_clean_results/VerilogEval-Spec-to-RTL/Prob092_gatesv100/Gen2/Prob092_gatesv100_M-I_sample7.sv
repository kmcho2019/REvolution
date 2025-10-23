module TopModule (
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Function to rotate right by 1 bit (wrap-around)
    function [99:0] rotate_right1;
        input [99:0] data;
        begin
            rotate_right1 = {data[0], data[99:1]};
        end
    endfunction

    // Compute out_both: in[i] & in[i+1] for i=0..98, zero out bit 99
    wire [99:0] both_tmp;
    assign both_tmp[98:0] = in[98:0] & in[99:1];
    assign both_tmp[99] = 1'b1; // temporary 1 to keep logic uniform, will mask out later

    // Compute out_any: in[i] | in[i-1] for i=1..99, zero out bit 0
    wire [99:0] any_tmp;
    assign any_tmp[99:1] = in[99:1] | in[98:0];
    assign any_tmp[0] = 1'b1; // temporary 1 to keep logic uniform, will mask out later

    // Compute out_different: in ^ rotate_right1(in)
    wire [99:0] rotated_in;
    assign rotated_in = rotate_right1(in);

    // Apply masks to zero boundary bits as per spec
    assign out_both      = both_tmp & {99{1'b1}, 1'b0};  // zero bit 99
    assign out_any       = any_tmp & {1'b0, 99{1'b1}};  // zero bit 0
    assign out_different = in ^ rotated_in;

endmodule
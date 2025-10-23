module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

wire upper_valid = |in[7:4];
wire lower_valid = |in[3:0];

// Priority encoder for 4 bits: outputs 2-bit position or 0 if none set.
function [1:0] priority4;
    input [3:0] bits;
    begin
        priority4 = bits[0] ? 2'd0 :
                    bits[1] ? 2'd1 :
                    bits[2] ? 2'd2 :
                    bits[3] ? 2'd3 :
                    2'd0;
    end
endfunction

wire [1:0] lower_pos = priority4(in[3:0]);
wire [1:0] upper_pos = priority4(in[7:4]);

assign pos = upper_valid ? {1'b1, upper_pos} :
             lower_valid ? {1'b0, lower_pos} :
             3'd0;

endmodule
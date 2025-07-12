module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    function [7:0] extract_byte;
        input [15:0] data;
        input        upper;  // 1 for upper byte, 0 for lower
        begin
            extract_byte = upper ? data[15:8] : data[7:0];
        end
    endfunction

    assign out_hi = extract_byte(in, 1'b1);
    assign out_lo = extract_byte(in, 1'b0);

endmodule
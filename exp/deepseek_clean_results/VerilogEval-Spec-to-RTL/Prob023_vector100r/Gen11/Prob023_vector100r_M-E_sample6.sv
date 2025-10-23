module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    function [WIDTH-1:0] reverse_bits;
        input [WIDTH-1:0] data;
        integer i;
        begin
            for (i = 0; i < WIDTH; i = i + 1) begin
                reverse_bits[i] = data[WIDTH-1 - i];
            end
        end
    endfunction

    assign out = reverse_bits(in);

endmodule
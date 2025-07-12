module TopModule (
    input  [99:0] in,
    output [99:0] out
);

function automatic [99:0] reverse_bits;
    input [99:0] data;
    integer width;
    integer half_width;
    begin
        width = 100;
        if (width <= 1) begin
            reverse_bits = data;
        end else begin
            half_width = width >> 1;
            reverse_bits = {reverse_bits(data[half_width-1:0]), 
                            reverse_bits(data[width-1:half_width])};
        end
    end
endfunction

assign out = reverse_bits(in);

endmodule
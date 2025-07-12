module TopModule (
    input  [99:0] in,
    output [99:0] out
);

function automatic [99:0] reverse_bits;
    input [99:0] data;
    integer width = 100;
    begin
        if (width <= 1) begin
            reverse_bits = data;
        end else begin
            // Swap upper and lower halves
            reverse_bits = {reverse_bits(data[width/2-1:0]), 
                           reverse_bits(data[width-1:width/2])};
        end
    end
endfunction

assign out = reverse_bits(in);

endmodule
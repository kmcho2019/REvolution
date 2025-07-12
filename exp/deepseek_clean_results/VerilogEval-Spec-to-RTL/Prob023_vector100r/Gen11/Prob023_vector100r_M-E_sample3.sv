module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    function automatic [99:0] reverse_bits;
        input [99:0] data;
        begin
            // Base case: 1-bit input
            if ($bits(data) == 1) begin
                reverse_bits = data;
            end
            // Recursive case: split and combine reversed halves
            else begin
                integer half_width = $bits(data)/2;
                reverse_bits = {reverse_bits(data[half_width-1:0]), 
                                reverse_bits(data[$bits(data)-1:half_width])};
            end
        end
    endfunction

    assign out = reverse_bits(in);

endmodule
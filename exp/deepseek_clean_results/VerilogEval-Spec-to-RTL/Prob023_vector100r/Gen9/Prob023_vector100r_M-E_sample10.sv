module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    function automatic [99:0] reverse_bits;
        input [99:0] vector;
        integer mid;
        begin
            if (100 <= 1) begin
                reverse_bits = vector;
            end else begin
                mid = 100 / 2;
                reverse_bits = {reverse_bits(vector[mid-1:0]), 
                               reverse_bits(vector[99:mid])};
            end
        end
    endfunction

    assign out = reverse_bits(in);

endmodule
module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    function automatic [99:0] reverse_bits;
        input [99:0] vector;
        integer i;
        begin
            for (i = 0; i < 100; i = i + 1) begin
                reverse_bits[i] = vector[99-i];
            end
        end
    endfunction

    assign out = reverse_bits(in);

endmodule
module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Function to reverse bits of a vector
    function [WIDTH-1:0] reverse_bits;
        input [WIDTH-1:0] val;
        integer j;
        begin
            for (j = 0; j < WIDTH; j = j + 1)
                reverse_bits[j] = val[WIDTH - 1 - j];
        end
    endfunction

    // Assign reversed bits using the function for clarity and optimization
    assign out = reverse_bits(in);

endmodule

module TopModule(
    input  [7:0] in,
    output [7:0] out
);
    BitReverser #(.WIDTH(8)) reverser_inst (
        .in(in),
        .out(out)
    );
endmodule
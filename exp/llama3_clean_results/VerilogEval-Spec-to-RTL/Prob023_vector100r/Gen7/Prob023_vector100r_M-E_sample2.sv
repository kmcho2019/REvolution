module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Function to reverse bits
    function [WIDTH-1:0] reverse_bits;
        input [WIDTH-1:0] data;
        begin
            automatic int i;
            for (i = 0; i < WIDTH / 2; i++) begin
                automatic bit temp = data[i];
                data[i] = data[WIDTH - 1 - i];
                data[WIDTH - 1 - i] = temp;
            end
            return data;
        end
    endfunction

    // Use the function to reverse the input bits
    assign out = reverse_bits(in);

endmodule
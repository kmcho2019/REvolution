module BitReverser #(parameter WIDTH = 8) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    // Function to build reversed concatenation
    function [WIDTH-1:0] reverse_bits;
        input [WIDTH-1:0] data_in;
        integer idx;
        begin
            reverse_bits = {WIDTH{1'b0}};
            for (idx = 0; idx < WIDTH; idx = idx + 1) begin
                reverse_bits[idx] = data_in[WIDTH - 1 - idx];
            end
        end
    endfunction

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
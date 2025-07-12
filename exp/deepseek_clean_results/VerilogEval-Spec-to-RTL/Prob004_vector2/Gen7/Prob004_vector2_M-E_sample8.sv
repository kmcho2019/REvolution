module TopModule #(
    parameter WIDTH = 32
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    function automatic [WIDTH-1:0] reverse_bytes;
        input [WIDTH-1:0] data;
        integer segment_size;
        begin
            if (WIDTH <= 8) begin
                reverse_bytes = data;  // Base case: single byte
            end else begin
                segment_size = WIDTH/2;
                // Swap upper and lower segments
                reverse_bytes = {reverse_bytes(data[segment_size-1:0]),
                                reverse_bytes(data[WIDTH-1:segment_size])};
            end
        end
    endfunction

    assign out = reverse_bytes(in);
endmodule
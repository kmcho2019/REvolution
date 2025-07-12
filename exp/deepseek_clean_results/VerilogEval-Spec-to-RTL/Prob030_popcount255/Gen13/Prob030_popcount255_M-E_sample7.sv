module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    // Convert each bit to 1-bit count
    wire [254:0] bit_counts = in;

    // Recursive parallel prefix adder tree
    function [7:0] parallel_add;
        input [254:0] bits;
        input [7:0] width;
        reg [7:0] left_sum, right_sum;
        begin
            if (width == 1) begin
                parallel_add = {7'b0, bits[0]};
            end
            else begin
                left_sum = parallel_add(bits[width/2-1:0], width/2);
                right_sum = parallel_add(bits[width-1:width/2], width - width/2);
                parallel_add = left_sum + right_sum;
            end
        end
    endfunction

    assign out = parallel_add(bit_counts, 255);

endmodule
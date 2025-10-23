module TopModule (
    input  [254:0] in,
    output [7:0]   out
);

    // Calculate the popcount width for given input width
    localparam integer WIDTH = 255;
    localparam integer OUT_WIDTH = $clog2(WIDTH + 1);

    // Recursive popcount function
    // Counts the number of 1's in 'data' of 'len' bits, returning sum in 'sum_width' bits
    function automatic [OUT_WIDTH-1:0] popcount_func;
        input [WIDTH-1:0] data;
        input integer len;
        integer half, left_len, right_len;
        reg [OUT_WIDTH-1:0] left_sum, right_sum;
        reg [7:0] base_in;
        reg [3:0] base_out;
        integer i;

        // Internal function implementing the balanced adder tree for 8 bits
        function automatic [3:0] popcount8_func;
            input [7:0] bits8;
            reg [1:0] sum_l1 [3:0];
            reg [2:0] sum_l2 [1:0];
            integer j;
        begin
            // Level 1: sum pairs of bits (2 bits each)
            for (j = 0; j < 4; j = j + 1) begin
                sum_l1[j] = bits8[2*j] + bits8[2*j+1];
            end
            // Level 2: sum pairs of level1 sums (3 bits each)
            for (j = 0; j < 2; j = j + 1) begin
                sum_l2[j] = sum_l1[2*j] + sum_l1[2*j+1];
            end
            // Level 3: sum the two level2 sums (4 bits result)
            popcount8_func = sum_l2[0] + sum_l2[1];
        end
        endfunction

    begin
        if (len <= 8) begin
            // Base case: zero-pad input LSB side to 8 bits
            base_in = 8'b0;
            for (i = 0; i < len; i = i +1)
                base_in[i] = data[i];
            base_out = popcount8_func(base_in);
            popcount_func = base_out;
        end else begin
            // Recursive case: split input approximately in half
            half = len / 2;
            left_len = half;
            right_len = len - half;

            // Extract left half and right half slices
            // Left half: lower bits [half-1:0]
            // Right half: upper bits [len-1:half]
            left_sum  = popcount_func(data[half-1:0], left_len);
            right_sum = popcount_func(data[len-1:half], right_len);

            // Sum partial results
            popcount_func = left_sum + right_sum;
        end
    end
    endfunction

    // Compute output by calling the recursive function on input
    assign out = popcount_func(in, WIDTH);

endmodule
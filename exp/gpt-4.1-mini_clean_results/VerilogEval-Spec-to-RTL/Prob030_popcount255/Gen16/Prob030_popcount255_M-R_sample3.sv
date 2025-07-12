module popcount8 (
    input  [7:0] in,
    output [3:0] out // max count 8 fits in 4 bits
);
    // Balanced explicit adder tree for 8 bits (structural)
    wire [1:0] sum_l1 [3:0];
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : l1
            assign sum_l1[i] = in[2*i] + in[2*i+1];
        end
    endgenerate

    wire [2:0] sum_l2 [1:0];
    generate
        for (i = 0; i < 2; i = i + 1) begin : l2
            assign sum_l2[i] = sum_l1[2*i] + sum_l1[2*i+1];
        end
    endgenerate

    assign out = sum_l2[0] + sum_l2[1];
endmodule


module popcount #(
    parameter WIDTH = 255
) (
    input  [WIDTH-1:0] in,
    output [$clog2(WIDTH+1)-1:0] out
);

    // Base case wires for popcount8
    // Will be used only when WIDTH <= 8
    localparam BASE_WIDTH = (WIDTH < 8) ? 8 : WIDTH;
    wire [3:0] base_count;
    wire [7:0] base_input;

    assign base_input = (WIDTH < 8) ? { {(8-WIDTH){1'b0}}, in } : in[7:0];

    popcount8 popcount8_inst (
        .in(base_input),
        .out(base_count)
    );

    // Recursive popcount function
    function automatic [$clog2(WIDTH+1)-1:0] popcount_recursive;
        input integer size;
        input [size-1:0] vec;

        integer half;
        reg [$clog2(size+1)-1:0] left_sum;
        reg [$clog2(size+1)-1:0] right_sum;
        reg [$clog2(size+1)-1:0] total;

        begin
            if (size <= 8) begin
                // zero-pad to 8 bits
                reg [7:0] padded;
                padded = { {(8-size){1'b0}}, vec };
                popcount_recursive = popcount8_fn(padded);
            end else begin
                half = size / 2;
                left_sum = popcount_recursive(half, vec[half-1:0]);
                right_sum = popcount_recursive(size - half, vec[size-1:half]);
                total = left_sum + right_sum;
                popcount_recursive = total;
            end
        end
    endfunction

    // Helper function for popcount8 (functional equivalent to popcount8 module)
    function automatic [3:0] popcount8_fn;
        input [7:0] v;
        reg [1:0] sum_l1 [3:0];
        reg [2:0] sum_l2 [1:0];
        begin
            sum_l1[0] = v[0] + v[1];
            sum_l1[1] = v[2] + v[3];
            sum_l1[2] = v[4] + v[5];
            sum_l1[3] = v[6] + v[7];

            sum_l2[0] = sum_l1[0] + sum_l1[1];
            sum_l2[1] = sum_l1[2] + sum_l1[3];

            popcount8_fn = sum_l2[0] + sum_l2[1];
        end
    endfunction

    // Assign output by calling the recursive function on input vector
    // This creates a combinational logic tree without submodule recursion
    assign out = popcount_recursive(WIDTH, in);

endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate the recursive popcount for 255 bits
    popcount #(.WIDTH(255)) u_popcount (
        .in(in),
        .out(out)
    );
endmodule
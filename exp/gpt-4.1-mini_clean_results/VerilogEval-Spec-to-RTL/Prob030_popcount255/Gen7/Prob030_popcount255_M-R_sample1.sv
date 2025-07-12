module popcount4 (
    input  [3:0] in,
    output [2:0] out // max count 4 -> 3 bits enough
);
    // Sum bits explicitly
    wire [1:0] sum01 = in[0] + in[1];
    wire [1:0] sum23 = in[2] + in[3];
    wire [2:0] total = sum01 + sum23;
    assign out = total;
endmodule

module popcount17 (
    input  [16:0] in,
    output [5:0] out  // max 17 ones, needs 5 bits, use 6 for safety
);
    wire [2:0] pc0, pc1, pc2, pc3;

    popcount4 pc_0 (.in(in[3:0]),    .out(pc0));
    popcount4 pc_1 (.in(in[7:4]),    .out(pc1));
    popcount4 pc_2 (.in(in[11:8]),   .out(pc2));
    popcount4 pc_3 (.in(in[15:12]),  .out(pc3));

    // sum pairs of pc4 results
    wire [4:0] sum01 = pc0 + pc1; 
    wire [4:0] sum23 = pc2 + pc3;

    wire [5:0] sum0123 = sum01 + sum23;
    assign out = sum0123 + in[16];
endmodule


module TopModule (
    input  [254:0] in,
    output [7:0] out
);
    // Instantiate 15 popcount17 modules for 255 bits (15*17)
    wire [5:0] partial_counts [0:14];
    genvar i;
    generate
        for(i = 0; i < 15; i = i + 1) begin : pc17_blocks
            popcount17 pc (
                .in(in[i*17 +: 17]),
                .out(partial_counts[i])
            );
        end
    endgenerate

    // Function: balanced recursive summation of an array of inputs
    // Inputs are zero-extended to the widest size before summation to avoid overflow.
    // We sum partial_counts[0..14] (6 bits each) to a single 8-bit output.
    function automatic [7:0] sum_array;
        input integer len;
        input [5:0] arr [0:len-1];
        reg [7:0] temp_arr [0:len-1];
        integer idx;
        begin
            // Zero-extend inputs to 8 bits
            for(idx=0; idx<len; idx=idx+1)
                temp_arr[idx] = {2'b00, arr[idx]};
            sum_array = recursive_sum(temp_arr, len);
        end
    endfunction

    // Recursive helper function to sum arrays in a balanced tree manner
    function automatic [7:0] recursive_sum;
        input [7:0] vals[];
        input integer len;
        reg [7:0] sum_vals [];
        integer i, new_len;
        begin
            if(len == 1) begin
                recursive_sum = vals[0];
            end else begin
                new_len = (len + 1) >> 1;
                sum_vals = new [7:0][0:new_len-1];
                for(i = 0; i < (len >> 1); i = i + 1) begin
                    sum_vals[i] = vals[2*i] + vals[2*i+1];
                end
                if(len & 1) begin
                    sum_vals[new_len-1] = vals[len-1];
                end
                recursive_sum = recursive_sum(sum_vals, new_len);
            end
        end
    endfunction

    // Combinational logic to compute the output using the recursive sum function
    assign out = sum_array(15, partial_counts);

endmodule
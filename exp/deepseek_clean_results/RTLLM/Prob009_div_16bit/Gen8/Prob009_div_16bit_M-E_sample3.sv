module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Parallel comparison units (4-bit slices)
    wire [3:0] cmp_high, cmp_mid, cmp_low;
    wire [7:0] rem_high, rem_mid, rem_low;
    
    // High nibble (bits 15-12)
    parallel_div_slice #(.WIDTH(4)) high_slice (
        .dividend(A[15:12]),
        .prev_rem(8'b0),
        .divisor(B),
        .quotient(cmp_high),
        .remainder(rem_high)
    );
    
    // Mid nibble (bits 11-8)
    parallel_div_slice #(.WIDTH(4)) mid_slice (
        .dividend(A[11:8]),
        .prev_rem(rem_high),
        .divisor(B),
        .quotient(cmp_mid),
        .remainder(rem_mid)
    );
    
    // Low nibble (bits 7-0)
    parallel_div_slice #(.WIDTH(8)) low_slice (
        .dividend(A[7:0]),
        .prev_rem(rem_mid),
        .divisor(B),
        .quotient(cmp_low),
        .remainder(rem_low)
    );
    
    // Combine results
    assign result = {cmp_high, cmp_mid, cmp_low[7:4], cmp_low[3:0]};
    assign odd = {8'b0, rem_low};

endmodule

module parallel_div_slice #(
    parameter WIDTH = 4
) (
    input [WIDTH-1:0] dividend,
    input [7:0] prev_rem,
    input [7:0] divisor,
    output [WIDTH-1:0] quotient,
    output [7:0] remainder
);
    
    // Internal wires for carry propagation
    wire [WIDTH:0][7:0] rem_chain;
    wire [WIDTH:0][WIDTH-1:0] quot_chain;
    
    // Initialize
    assign rem_chain[0] = prev_rem;
    assign quot_chain[0] = {WIDTH{1'b0}};
    
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : slice
            wire [8:0] current = {rem_chain[i], dividend[WIDTH-1-i]};
            wire do_sub = (current >= {1'b0, divisor});
            
            assign rem_chain[i+1] = do_sub ? (current - divisor) : current[7:0];
            assign quot_chain[i+1] = {quot_chain[i][WIDTH-2:0], do_sub};
        end
    endgenerate
    
    assign quotient = quot_chain[WIDTH];
    assign remainder = rem_chain[WIDTH];
    
endmodule
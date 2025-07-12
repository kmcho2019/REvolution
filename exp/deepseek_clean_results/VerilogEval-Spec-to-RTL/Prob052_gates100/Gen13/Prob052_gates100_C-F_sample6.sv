module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Function to compute AND of a slice
    function automatic logic slice_and(input [24:0] slice_in);
        logic [24:0] chain;
        chain[0] = slice_in[0];
        for (int i = 1; i < 25; i++) begin
            chain[i] = chain[i-1] & slice_in[i];
        end
        return chain[24];
    endfunction

    // Function to compute OR of a slice
    function automatic logic slice_or(input [24:0] slice_in);
        logic [24:0] chain;
        chain[0] = slice_in[0];
        for (int i = 1; i < 25; i++) begin
            chain[i] = chain[i-1] | slice_in[i];
        end
        return chain[24];
    endfunction

    // Function to compute XOR of a slice
    function automatic logic slice_xor(input [24:0] slice_in);
        logic [24:0] chain;
        chain[0] = slice_in[0];
        for (int i = 1; i < 25; i++) begin
            chain[i] = chain[i-1] ^ slice_in[i];
        end
        return chain[24];
    endfunction

    // Compute slice results
    wire [3:0] and_results = {
        slice_and(in[99:75]),
        slice_and(in[74:50]),
        slice_and(in[49:25]),
        slice_and(in[24:0])
    };

    wire [3:0] or_results = {
        slice_or(in[99:75]),
        slice_or(in[74:50]),
        slice_or(in[49:25]),
        slice_or(in[24:0])
    };

    wire [3:0] xor_results = {
        slice_xor(in[99:75]),
        slice_xor(in[74:50]),
        slice_xor(in[49:25]),
        slice_xor(in[24:0])
    };

    // Combine slice results
    assign out_and = &and_results;
    assign out_or  = |or_results;
    assign out_xor = ^xor_results;

endmodule
module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Function to perform balanced tree AND reduction on input vector of arbitrary size
    function automatic [0:0] tree_and;
        input [0:0] data[];
        integer n;
        integer i;
        reg [0:0] temp[];
        begin
            n = data.size();
            if (n == 1) begin
                tree_and = data[0];
            end else begin
                // If odd number, extend with 1 to keep identity for AND
                if (n % 2 != 0) begin
                    // Create temp array of (n+1)/2 elements
                    temp = new[(n+1)/2];
                    // Pairwise AND
                    for (i = 0; i < n-1; i = i + 2)
                        temp[i/2] = data[i] & data[i+1];
                    temp[(n-1)/2] = data[n-1] & 1'b1; // last element & 1
                end else begin
                    temp = new[n/2];
                    for (i = 0; i < n; i = i + 2)
                        temp[i/2] = data[i] & data[i+1];
                end
                tree_and = tree_and(temp);
            end
        end
    endfunction

    // Function to perform balanced tree OR reduction on input vector of arbitrary size
    function automatic [0:0] tree_or;
        input [0:0] data[];
        integer n;
        integer i;
        reg [0:0] temp[];
        begin
            n = data.size();
            if (n == 1) begin
                tree_or = data[0];
            end else begin
                if (n % 2 != 0) begin
                    temp = new[(n+1)/2];
                    for (i = 0; i < n-1; i = i + 2)
                        temp[i/2] = data[i] | data[i+1];
                    temp[(n-1)/2] = data[n-1] | 1'b0; // last element | 0
                end else begin
                    temp = new[n/2];
                    for (i = 0; i < n; i = i + 2)
                        temp[i/2] = data[i] | data[i+1];
                end
                tree_or = tree_or(temp);
            end
        end
    endfunction

    // Function to perform balanced tree XOR reduction on input vector of arbitrary size
    function automatic [0:0] tree_xor;
        input [0:0] data[];
        integer n;
        integer i;
        reg [0:0] temp[];
        begin
            n = data.size();
            if (n == 1) begin
                tree_xor = data[0];
            end else begin
                if (n % 2 != 0) begin
                    temp = new[(n+1)/2];
                    for (i = 0; i < n-1; i = i + 2)
                        temp[i/2] = data[i] ^ data[i+1];
                    temp[(n-1)/2] = data[n-1] ^ 1'b0; // last element ^ 0
                end else begin
                    temp = new[n/2];
                    for (i = 0; i < n; i = i + 2)
                        temp[i/2] = data[i] ^ data[i+1];
                end
                tree_xor = tree_xor(temp);
            end
        end
    endfunction

    // Convert input vector to dynamic array of single bits for functions
    wire [0:0] in_bits [0:99];
    genvar idx;
    generate
        for (idx = 0; idx < 100; idx = idx + 1) begin : IN_BITS_ASSIGN
            assign in_bits[idx] = in[idx];
        end
    endgenerate

    assign out_and = tree_and(in_bits);
    assign out_or  = tree_or(in_bits);
    assign out_xor = tree_xor(in_bits);

endmodule
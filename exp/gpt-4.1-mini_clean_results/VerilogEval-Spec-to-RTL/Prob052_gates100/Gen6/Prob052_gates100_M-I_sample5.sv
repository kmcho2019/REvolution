module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Parameters for tree stages (power of 2 >= 100)
    localparam N = 128; // Next power of two >= 100

    // Extend input with 1's (AND identity) or 0's (OR identity) or 0's (XOR identity)
    wire [N-1:0] in_and_extended;
    wire [N-1:0] in_or_extended;
    wire [N-1:0] in_xor_extended;

    // Padding input to next power of two with identity elements:
    // For AND: identity is 1, so pad with 1
    // For OR:  identity is 0, so pad with 0
    // For XOR: identity is 0, so pad with 0

    assign in_and_extended = { {(N-100){1'b1}}, in };
    assign in_or_extended  = { {(N-100){1'b0}}, in };
    assign in_xor_extended = { {(N-100){1'b0}}, in };

    // Function to implement balanced binary tree AND reduction
    function automatic [N-1:0] reduce_and_tree;
        input [N-1:0] data_in;
        integer size;
        integer i;
        reg [N-1:0] stage;
        begin
            stage = data_in;
            size = N;
            // Reduce stage by stage until 1 bit remains
            while (size > 1) begin
                for (i = 0; i < size/2; i = i + 1) begin
                    stage[i] = stage[2*i] & stage[2*i+1];
                end
                size = size / 2;
            end
            reduce_and_tree = stage;
        end
    endfunction

    // Function to implement balanced binary tree OR reduction
    function automatic [N-1:0] reduce_or_tree;
        input [N-1:0] data_in;
        integer size;
        integer i;
        reg [N-1:0] stage;
        begin
            stage = data_in;
            size = N;
            while (size > 1) begin
                for (i = 0; i < size/2; i = i + 1) begin
                    stage[i] = stage[2*i] | stage[2*i+1];
                end
                size = size / 2;
            end
            reduce_or_tree = stage;
        end
    endfunction

    // Function to implement balanced binary tree XOR reduction
    function automatic [N-1:0] reduce_xor_tree;
        input [N-1:0] data_in;
        integer size;
        integer i;
        reg [N-1:0] stage;
        begin
            stage = data_in;
            size = N;
            while (size > 1) begin
                for (i = 0; i < size/2; i = i + 1) begin
                    stage[i] = stage[2*i] ^ stage[2*i+1];
                end
                size = size / 2;
            end
            reduce_xor_tree = stage;
        end
    endfunction

    // Calculate outputs via balanced tree reductions
    wire [N-1:0] and_result = reduce_and_tree(in_and_extended);
    wire [N-1:0] or_result  = reduce_or_tree(in_or_extended);
    wire [N-1:0] xor_result = reduce_xor_tree(in_xor_extended);

    assign out_and = and_result[0];
    assign out_or  = or_result[0];
    assign out_xor = xor_result[0];

endmodule
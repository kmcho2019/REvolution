module TopModule (
    input  [99:0] in,
    output        out_and,
    output        out_or,
    output        out_xor
);

    // Calculate minimum power of two >= 100 for padding
    localparam N = 128; // next power of two >= 100

    // Pad inputs with 1 (neutral for AND), 0 (neutral for OR), 0 (neutral for XOR)
    wire [N-1:0] in_and_pad;
    wire [N-1:0] in_or_pad;
    wire [N-1:0] in_xor_pad;

    genvar i;
    generate
        for(i = 0; i < 100; i = i + 1) begin : gen_input_assign
            assign in_and_pad[i] = in[i];
            assign in_or_pad[i]  = in[i];
            assign in_xor_pad[i] = in[i];
        end
        for(i = 100; i < N; i = i + 1) begin : gen_pad_values
            assign in_and_pad[i] = 1'b1; // AND neutral element
            assign in_or_pad[i]  = 1'b0; // OR neutral element
            assign in_xor_pad[i] = 1'b0; // XOR neutral element
        end
    endgenerate

    // Recursive function to build reduction tree for AND, OR, XOR
    function automatic [N-1:0] reduce_and;
        input [N-1:0] vec;
        integer len, j;
        reg [N-1:0] tmp;
        begin
            len = N;
            tmp = vec;
            while(len > 1) begin
                for(j = 0; j < len/2; j = j + 1) begin
                    tmp[j] = tmp[2*j] & tmp[2*j+1];
                end
                len = len / 2;
            end
            reduce_and = tmp;
        end
    endfunction

    function automatic [N-1:0] reduce_or;
        input [N-1:0] vec;
        integer len, j;
        reg [N-1:0] tmp;
        begin
            len = N;
            tmp = vec;
            while(len > 1) begin
                for(j = 0; j < len/2; j = j + 1) begin
                    tmp[j] = tmp[2*j] | tmp[2*j+1];
                end
                len = len / 2;
            end
            reduce_or = tmp;
        end
    endfunction

    function automatic [N-1:0] reduce_xor;
        input [N-1:0] vec;
        integer len, j;
        reg [N-1:0] tmp;
        begin
            len = N;
            tmp = vec;
            while(len > 1) begin
                for(j = 0; j < len/2; j = j + 1) begin
                    tmp[j] = tmp[2*j] ^ tmp[2*j+1];
                end
                len = len / 2;
            end
            reduce_xor = tmp;
        end
    endfunction

    // Assign outputs from reduction trees (take first element as final output)
    assign out_and = reduce_and(in_and_pad)[0];
    assign out_or  = reduce_or(in_or_pad)[0];
    assign out_xor = reduce_xor(in_xor_pad)[0];

endmodule
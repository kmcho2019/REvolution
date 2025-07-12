module TopModule (
    input  [99:0] in,
    output reg    out_and,
    output reg    out_or,
    output reg    out_xor
);

    // Function for balanced reduction AND
    function automatic bit reduce_and(input bit [99:0] data);
        integer width;
        bit [99:0] temp;
        begin
            temp = data;
            width = 100;
            while (width > 1) begin
                for (integer i = 0; i < width/2; i = i + 1)
                    temp[i] = temp[2*i] & temp[2*i+1];
                if (width[0]) // odd width
                    temp[width/2] = temp[width-1];
                width = (width + 1) >> 1;
            end
            reduce_and = temp[0];
        end
    endfunction

    // Function for balanced reduction OR
    function automatic bit reduce_or(input bit [99:0] data);
        integer width;
        bit [99:0] temp;
        begin
            temp = data;
            width = 100;
            while (width > 1) begin
                for (integer i = 0; i < width/2; i = i + 1)
                    temp[i] = temp[2*i] | temp[2*i+1];
                if (width[0]) // odd width
                    temp[width/2] = temp[width-1];
                width = (width + 1) >> 1;
            end
            reduce_or = temp[0];
        end
    endfunction

    // Function for balanced reduction XOR
    function automatic bit reduce_xor(input bit [99:0] data);
        integer width;
        bit [99:0] temp;
        begin
            temp = data;
            width = 100;
            while (width > 1) begin
                for (integer i = 0; i < width/2; i = i + 1)
                    temp[i] = temp[2*i] ^ temp[2*i+1];
                if (width[0]) // odd width
                    temp[width/2] = temp[width-1];
                width = (width + 1) >> 1;
            end
            reduce_xor = temp[0];
        end
    endfunction

    always @(*) begin
        out_and = reduce_and(in);
        out_or  = reduce_or(in);
        out_xor = reduce_xor(in);
    end

endmodule
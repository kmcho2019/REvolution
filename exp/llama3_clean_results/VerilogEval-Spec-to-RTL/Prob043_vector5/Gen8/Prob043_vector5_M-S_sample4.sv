module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    genvar i, j;
    generate
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                assign out[i*5 + j] = ~(get_input(i) ^ get_input(j));
            end
        end
    endgenerate

    function input get_input;
        input idx;
        case (idx)
            0: get_input = a;
            1: get_input = b;
            2: get_input = c;
            3: get_input = d;
            4: get_input = e;
        endcase
    endfunction
endmodule
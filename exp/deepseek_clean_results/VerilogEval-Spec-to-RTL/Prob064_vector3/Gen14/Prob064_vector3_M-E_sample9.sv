module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Function to get the appropriate input bit based on position
    function automatic get_input_bit;
        input [5:0] pos;
        begin
            if (pos < 5) get_input_bit = a[pos];
            else if (pos < 10) get_input_bit = b[pos-5];
            else if (pos < 15) get_input_bit = c[pos-10];
            else if (pos < 20) get_input_bit = d[pos-15];
            else if (pos < 25) get_input_bit = e[pos-20];
            else if (pos < 30) get_input_bit = f[pos-25];
            else get_input_bit = 1'b1; // Padding bits
        end
    endfunction

    // Assign each output bit individually
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : assign_w
            assign w[i] = get_input_bit(31 - i);
        end
        for (i = 0; i < 8; i = i + 1) begin : assign_x
            assign x[i] = get_input_bit(23 - i);
        end
        for (i = 0; i < 8; i = i + 1) begin : assign_y
            assign y[i] = get_input_bit(15 - i);
        end
        for (i = 0; i < 8; i = i + 1) begin : assign_z
            assign z[i] = get_input_bit(7 - i);
        end
    endgenerate

endmodule
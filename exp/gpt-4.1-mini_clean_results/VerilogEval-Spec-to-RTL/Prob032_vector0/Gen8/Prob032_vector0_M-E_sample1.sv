module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign outv to vec
    assign outv = vec;

    // Use generate to assign individual bits to outputs systematically
    generate
        genvar i;
        for (i = 0; i < 3; i = i + 1) begin : bit_assign
            // Conditional continuous assignments based on index
            if (i == 0) assign o0 = vec[i];
            else if (i == 1) assign o1 = vec[i];
            else if (i == 2) assign o2 = vec[i];
        end
    endgenerate
endmodule
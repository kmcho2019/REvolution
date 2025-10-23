module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Assign outv directly from vec
    assign outv = vec;

    // Use generate block to assign individual bits to outputs
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_assign
            if (i == 0) assign o0 = vec[i];
            else if (i == 1) assign o1 = vec[i];
            else if (i == 2) assign o2 = vec[i];
        end
    endgenerate

endmodule
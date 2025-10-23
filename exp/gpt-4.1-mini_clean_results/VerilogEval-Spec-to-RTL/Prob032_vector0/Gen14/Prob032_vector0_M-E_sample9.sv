module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Declare a wire array for individual bit outputs to enable generate loop
    wire [2:0] bits;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_assign
            assign bits[i] = vec[i];
        end
    endgenerate

    // Assign output vector from bits array
    assign outv = bits;

    // Connect each individual output to corresponding bit
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];

endmodule
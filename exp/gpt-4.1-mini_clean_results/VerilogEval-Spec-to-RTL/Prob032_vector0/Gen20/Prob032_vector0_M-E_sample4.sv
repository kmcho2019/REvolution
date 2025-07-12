module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Declare internal wires for each bit extracted from vec
    wire [2:0] bits;

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : bit_extract
            assign bits[i] = vec[i];
        end
    endgenerate

    // Assign outv by concatenating bits in reverse order to demonstrate flexibility
    assign outv = {bits[2], bits[1], bits[0]};

    // Map individual bits to corresponding outputs
    assign o0 = bits[0];
    assign o1 = bits[1];
    assign o2 = bits[2];
endmodule
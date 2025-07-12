module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Define a 5-entry ROM of 4-bit vectors containing the source inputs and 4'hF
    wire [3:0] data [0:4];
    assign data[0] = b;
    assign data[1] = e;
    assign data[2] = a;
    assign data[3] = d;
    assign data[4] = 4'hF;

    // Clip index c to max 4 to avoid out-of-bound indexing
    wire [2:0] idx = (c < 4'd5) ? c[2:0] : 3'd4;

    // Assign output q by selecting the element at idx
    assign q = data[idx];

endmodule
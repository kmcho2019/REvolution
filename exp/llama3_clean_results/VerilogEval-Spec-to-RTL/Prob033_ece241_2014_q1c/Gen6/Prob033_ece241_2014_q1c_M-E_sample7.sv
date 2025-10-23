module TopModule(
    input  [7:0] a,  // 8-bit 2's complement input number
    input  [7:0] b,  // 8-bit 2's complement input number
    output [7:0] s,  // 8-bit result of the addition
    output      overflow  // indicator of signed overflow
);

    // Internal wires for the parallel prefix adder
    wire [7:0] g;  // generate signals
    wire [7:0] p;  // propagate signals
    wire [7:0] p1;  // prefix signals for 1-bit positions
    wire [6:0] p2;  // prefix signals for 2-bit positions
    wire [5:0] p3;  // prefix signals for 4-bit positions
    wire [4:0] p4;  // prefix signals for 8-bit positions
    wire [7:0] sum;  // sum bits
    wire c_out;  // carry-out of the MSB

    // Generate stage
    assign g[0] = a[0] & b[0];
    assign p[0] = a[0] | b[0];
    for (genvar i = 1; i < 8; i++) begin
        assign g[i] = a[i] & b[i];
        assign p[i] = a[i] | b[i];
    end

    // Propagate stage
    assign p1[0] = p[0];
    for (genvar i = 1; i < 7; i++) begin
        assign p1[i] = p[i] & p1[i-1];
    end
    assign p2[0] = p1[0] & p1[1];
    for (genvar i = 1; i < 6; i++) begin
        assign p2[i] = p1[i] & p1[i+1];
    end
    assign p3[0] = p2[0] & p2[1];
    for (genvar i = 1; i < 5; i++) begin
        assign p3[i] = p2[i] & p2[i+1];
    end
    assign p4[0] = p3[0] & p3[1];
    for (genvar i = 1; i < 4; i++) begin
        assign p4[i] = p3[i] & p3[i+1];
    end

    // Sum stage
    assign sum[0] = a[0] ^ b[0];
    for (genvar i = 1; i < 8; i++) begin
        assign sum[i] = a[i] ^ b[i] ^ p4[i-1];
    end

    // Carry-out of the MSB
    assign c_out = g[7] | (p[7] & p4[3]);

    // Assign the result of the addition
    assign s = sum;

    // Detect signed overflow
    assign overflow = (a[7] == b[7] && a[7] != s[7]);

endmodule
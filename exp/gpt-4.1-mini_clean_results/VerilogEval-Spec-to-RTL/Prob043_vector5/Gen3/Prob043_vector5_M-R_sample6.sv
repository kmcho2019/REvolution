module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {e, d, c, b, a};
    wire [4:0] comp_row [4:0]; // 5 rows of 5 bits each
    
    // Compute pairwise equality bits for each row
    assign comp_row[0] = {~(inputs[0] ^ inputs[0]),
                          ~(inputs[0] ^ inputs[1]),
                          ~(inputs[0] ^ inputs[2]),
                          ~(inputs[0] ^ inputs[3]),
                          ~(inputs[0] ^ inputs[4])};
                          
    assign comp_row[1] = {~(inputs[1] ^ inputs[0]),
                          ~(inputs[1] ^ inputs[1]),
                          ~(inputs[1] ^ inputs[2]),
                          ~(inputs[1] ^ inputs[3]),
                          ~(inputs[1] ^ inputs[4])};
                          
    assign comp_row[2] = {~(inputs[2] ^ inputs[0]),
                          ~(inputs[2] ^ inputs[1]),
                          ~(inputs[2] ^ inputs[2]),
                          ~(inputs[2] ^ inputs[3]),
                          ~(inputs[2] ^ inputs[4])};
                          
    assign comp_row[3] = {~(inputs[3] ^ inputs[0]),
                          ~(inputs[3] ^ inputs[1]),
                          ~(inputs[3] ^ inputs[2]),
                          ~(inputs[3] ^ inputs[3]),
                          ~(inputs[3] ^ inputs[4])};
                          
    assign comp_row[4] = {~(inputs[4] ^ inputs[0]),
                          ~(inputs[4] ^ inputs[1]),
                          ~(inputs[4] ^ inputs[2]),
                          ~(inputs[4] ^ inputs[3]),
                          ~(inputs[4] ^ inputs[4])};
                          
    // Flatten the matrix comp_row[4:0][4:0] into the output vector out[24:0].
    // The bit out[(4 - i)*5 + (4 - j)] = comp_row[i][j]
    // The output bits are assigned starting from bit 24 down to bit 0.
    assign out = {comp_row[4], comp_row[3], comp_row[2], comp_row[1], comp_row[0]};
endmodule
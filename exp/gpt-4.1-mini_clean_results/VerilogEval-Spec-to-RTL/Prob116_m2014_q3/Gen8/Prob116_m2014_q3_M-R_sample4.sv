module TopModule(
    input  [3:0] x, // x[3], x[2], x[1], x[0] corresponding to inputs x[4], x[3], x[2], x[1]
    output reg    f
);
    /*
    Mapping inputs:
    Problem bits: x[1], x[2], x[3], x[4]
    Verilog bits: x[0], x[1], x[2], x[3]

    So:
    x[0] -> x[1]
    x[1] -> x[2]
    x[2] -> x[3]
    x[3] -> x[4]

    Karnaugh map indexes:
    row bits = x[3]x[4] = {x[4], x[3]} = {x[3], x[2]} in Verilog's x
    column bits = x[1]x[2] = {x[2], x[1]} = {x[1], x[0]} in Verilog's x

    Therefore, to index the K-map, construct:
    kmap_index = {x[3], x[2], x[1], x[0]} = {x[4], x[3], x[2], x[1]} as given

    We directly use x as kmap_index.
    */

    always @(*) begin
        case (x)
            // Row=00 (x[3]x[4]=00)
            4'b0000: f = 1'b0; // d -> 0
            4'b0001: f = 1'b0;
            4'b0011: f = 1'b0; // d -> 0
            4'b0010: f = 1'b0; // d -> 0

            // Row=01 (x[3]x[4]=01)
            4'b0100: f = 1'b0;
            4'b0101: f = 1'b0; // d -> 0
            4'b0111: f = 1'b1;
            4'b0110: f = 1'b0;

            // Row=11 (x[3]x[4]=11)
            4'b1100: f = 1'b1;
            4'b1101: f = 1'b1;
            4'b1111: f = 1'b0; // d -> 0
            4'b1110: f = 1'b0; // d -> 0

            // Row=10 (x[3]x[4]=10)
            4'b1000: f = 1'b1;
            4'b1001: f = 1'b1;
            4'b1011: f = 1'b0; // d -> 0
            4'b1010: f = 1'b0; // d -> 0

            default: f = 1'b0;
        endcase
    end

endmodule
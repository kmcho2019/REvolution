module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in the K-map
    output f
);
    // First level muxes for each row (controlled by x[2])
    wire mux_row0 = x[2] ? 1'b0 : 1'b0;  // Row 00: Choose 0 for both cases
    wire mux_row1 = x[2] ? 1'b1 : 1'b0;   // Row 01: 0 when x[2]=0, 1 when x[2]=1
    wire mux_row2 = x[2] ? 1'b1 : 1'b1;   // Row 11: Choose 1 for both cases
    wire mux_row3 = x[2] ? 1'b0 : 1'b1;   // Row 10: 1 when x[2]=0, 0 when x[2]=1

    // Top level 4:1 mux (controlled by x[3] and x[4])
    assign f = (x[3:4] == 2'b00) ? mux_row0 :
               (x[3:4] == 2'b01) ? mux_row1 :
               (x[3:4] == 2'b11) ? mux_row2 :
               mux_row3;
endmodule
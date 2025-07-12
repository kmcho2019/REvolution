module TopModule(
    input [3:0] x,  // x[3:0] represents x[4:1] in K-map
    output f
);
    // Implement each row of the K-map as a mux input
    wire [3:0] mux_inputs;
    assign mux_inputs[0] = (x[1:0] == 2'b01) ? 1'b0 : 1'b1;  // Row 00: d->1, 0, d->1, d->1
    assign mux_inputs[1] = (x[1:0] == 2'b00 || x[1:0] == 2'b10) ? 1'b0 : 
                          (x[1:0] == 2'b11) ? 1'b1 : 1'b0;    // Row 01: 0, d->0, 1, 0
    assign mux_inputs[2] = (x[1:0] == 2'b00 || x[1:0] == 2'b01) ? 1'b1 : 1'b0;  // Row 11: 1,1,d->0,d->0
    assign mux_inputs[3] = (x[1:0] == 2'b11) ? 1'b0 : 1'b1;   // Row 10: 1,1,0,d->1

    // Use x[3:4] as mux selector
    assign f = mux_inputs[{x[3], x[4]}];
endmodule
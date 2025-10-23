module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Compute row signals based on ab inputs for each cd combination

wire row0; // c=0 d=0
wire row1; // c=0 d=1
wire row2; // c=1 d=0
wire row3; // c=1 d=1

assign row0 = (~a) | (~b);  // from K-map row 00
assign row1 = ~b;           // from K-map row 01
assign row2 = ~a;           // from K-map row 10
assign row3 = a  | b;       // from K-map row 11

// Select line for 4:1 MUX: {c,d}
// c is MSB, d is LSB

reg mux_out;
always @(*) begin
    case ({c,d})
        2'b00: mux_out = row0;
        2'b01: mux_out = row1;
        2'b10: mux_out = row2;
        2'b11: mux_out = row3;
        default: mux_out = 1'b0; // Should never occur
    endcase
end

assign out = mux_out;

endmodule
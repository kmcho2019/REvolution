module TopModule (
    input  clk,
    input  j,
    input  k,
    output reg Q
);

always @(posedge clk) begin
    // Compute next state using JK characteristic equation:
    // Q_next = (J & ~Q) | (~K & Q)
    // Only update Q if next state differs to reduce toggling (power optimization)
    case ({j,k})
        2'b00: ; // Q holds its value
        2'b01: if (Q != 1'b0) Q <= 1'b0;
        2'b10: if (Q != 1'b1) Q <= 1'b1;
        2'b11: Q <= ~Q;
    endcase
end

endmodule
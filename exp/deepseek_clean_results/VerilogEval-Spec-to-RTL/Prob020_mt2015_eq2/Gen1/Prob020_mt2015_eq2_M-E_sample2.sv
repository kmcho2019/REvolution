module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);

    // Treat B as selector for 4:1 mux
    // Each mux input corresponds to a possible B value (00-11)
    assign z = (B == 2'b00) ? (A == 2'b00) :
               (B == 2'b01) ? (A == 2'b01) :
               (B == 2'b10) ? (A == 2'b10) :
                               (A == 2'b11);

endmodule
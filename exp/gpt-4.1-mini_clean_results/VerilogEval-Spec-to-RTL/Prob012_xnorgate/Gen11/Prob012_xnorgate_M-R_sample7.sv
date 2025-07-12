module TopModule(
    input  a,
    input  b,
    output reg out
);

    // Combinational logic implemented with always @(*) block
    always @(*) begin
        out = a ~^ b;  // XNOR operation using blocking assignment
    end

endmodule
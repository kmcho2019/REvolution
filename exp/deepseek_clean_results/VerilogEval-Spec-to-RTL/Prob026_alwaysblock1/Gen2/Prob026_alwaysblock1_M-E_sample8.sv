module TopModule (
    input  a,
    input  b,
    output out_assign,
    output reg out_alwaysblock
);

    // Standard AND implementation using assign
    assign out_assign = a & b;

    // Mux-based AND implementation
    always @(*) begin
        case (b)
            1'b1: out_alwaysblock = a;
            1'b0: out_alwaysblock = 1'b0;
        endcase
    end

endmodule
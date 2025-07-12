module TopModule (
    input  wire x3,
    input  wire x2,
    input  wire x1,
    output reg  f
);

    always @(*) begin
        // Implement f as a mux controlled by x3:
        // If x3=0, output f = x2
        // If x3=1, output f = x1
        case (x3)
            1'b0: f = x2;
            1'b1: f = x1;
            default: f = 1'b0; // default case for safety
        endcase
    end

endmodule
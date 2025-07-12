module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state logic using case statement for better optimization
    always @(*) begin
        case ({x, y})
            4'b0_000: Y0 = 1'b0;
            4'b0_001: Y0 = 1'b1;
            4'b0_010: Y0 = 1'b0;
            4'b0_011: Y0 = 1'b1;
            4'b0_100: Y0 = 1'b1;
            4'b1_000: Y0 = 1'b1;
            4'b1_001: Y0 = 1'b0;
            4'b1_010: Y0 = 1'b1;
            4'b1_011: Y0 = 1'b0;
            4'b1_100: Y0 = 1'b0;
            default:  Y0 = 1'b0; // Should never occur
        endcase
    end

    // Output z is 1 when y is 011 or 100
    assign z = y[2] | (y[1] & y[0]);

endmodule
module TopModule(
    input x,
    input y,
    output z
);

    // Define the lookup table
    reg [1:0] lut_address;
    assign lut_address = {x, y};
    
    // Use a case statement to implement the LUT
    always @(*) begin
        case(lut_address)
            2'b00: z = 1'b1;
            2'b01: z = 1'b0;
            2'b10: z = 1'b0;
            2'b11: z = 1'b1;
            default: z = 1'bx;
        endcase
    end

endmodule
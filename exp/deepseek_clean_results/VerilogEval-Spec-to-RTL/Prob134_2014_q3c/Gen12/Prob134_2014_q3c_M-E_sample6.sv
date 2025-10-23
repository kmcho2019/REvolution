module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined LUT for Y0 and z outputs
    // Index format: {x, y[2:0]}
    // Output format: {Y0, z}
    reg [1:0] lut_out;
    
    always @(*) begin
        case ({x, y})
            4'b0000: lut_out = 2'b00; // 000 -> 000, z=0
            4'b1000: lut_out = 2'b10; // 000 -> 001, z=0
            4'b0001: lut_out = 2'b10; // 001 -> 001, z=0
            4'b1001: lut_out = 2'b00; // 001 -> 100, z=0
            4'b0010: lut_out = 2'b00; // 010 -> 010, z=0
            4'b1010: lut_out = 2'b10; // 010 -> 001, z=0
            4'b0011: lut_out = 2'b11; // 011 -> 001, z=1
            4'b1011: lut_out = 2'b01; // 011 -> 010, z=1
            4'b0100: lut_out = 2'b11; // 100 -> 011, z=1
            4'b1100: lut_out = 2'b01; // 100 -> 100, z=1
            default: lut_out = 2'b00; // undefined states
        endcase
    end

    assign Y0 = lut_out[1];
    assign z = lut_out[0];

endmodule
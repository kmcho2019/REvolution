module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Define the LUTs for the population count
    wire [1:0] lut_out_lsb;
    wire [1:0] lut_out_msb;

    // Use a simple encoder for the LSB part
    always @(*) begin
        case (in[1:0])
            2'b00: lut_out_lsb = 2'b00;
            2'b01, 2'b10: lut_out_lsb = 2'b01;
            2'b11: lut_out_lsb = 2'b10;
        endcase
    end

    // Use a simple encoder for the MSB part
    always @(*) begin
        case (in[2])
            1'b0: lut_out_msb = 2'b00;
            1'b1: lut_out_msb = 2'b01;
        endcase
    end

    // Add the results from the two LUTs to obtain the final population count
    assign out = lut_out_lsb + lut_out_msb;

endmodule
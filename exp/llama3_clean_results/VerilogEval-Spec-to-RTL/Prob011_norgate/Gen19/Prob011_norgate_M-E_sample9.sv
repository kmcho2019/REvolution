module TopModule(
    input  logic a,  // Input signal a
    input  logic b,  // Input signal b
    output logic out  // Output signal out
);
    // Define the LUT for NOR gate
    logic [3:0] lut_nor[3:0];  // 4x4 LUT, but we only need 4 entries for NOR

    // Initialize the LUT with NOR gate truth table
    initial begin
        lut_nor[0] = 4'b0001;  // a=0, b=0, out=1
        lut_nor[1] = 4'b0010;  // a=0, b=1, out=0
        lut_nor[2] = 4'b0100;  // a=1, b=0, out=0
        lut_nor[3] = 4'b1000;  // a=1, b=1, out=0
    end

    // Use the LUT to compute the output
    always @(*) begin
        case ({a, b})
            2'b00: out = 1'b1;  // a=0, b=0
            2'b01: out = 1'b0;  // a=0, b=1
            2'b10: out = 1'b0;  // a=1, b=0
            2'b11: out = 1'b0;  // a=1, b=1
        endcase
    end
endmodule
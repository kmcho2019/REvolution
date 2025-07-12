module TopModule(
    input  logic a,
    input  logic b,
    output logic sum,
    output logic cout
);
    // Define the lookup table for the half adder
    // The first bit of each entry is the carry-out, and the second bit is the sum
    logic [1:0] lut[2:0];
    initial begin
        lut[0] = 2'b00; // For inputs 00
        lut[1] = 2'b01; // For inputs 01
        lut[2] = 2'b10; // For inputs 10
        lut[3] = 2'b11; // For inputs 11
    end
    
    // Use the LUT to determine the sum and carry-out
    always @(*) begin
        if (a == 1'b0 && b == 1'b0) begin
            {cout, sum} = lut[0];
        end else if (a == 1'b0 && b == 1'b1) begin
            {cout, sum} = lut[1];
        end else if (a == 1'b1 && b == 1'b0) begin
            {cout, sum} = lut[2];
        end else begin
            {cout, sum} = lut[3];
        end
    end
endmodule
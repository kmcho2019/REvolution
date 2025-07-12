module TopModule (
    input in,
    output reg out
);
    reg [1:0] not_lut; // 2-bit memory for NOT truth table

    // Initialize LUT with NOT truth table (0->1, 1->0)
    initial begin
        not_lut[0] = 1'b1; // Address 0
        not_lut[1] = 1'b0; // Address 1
    end

    // Use input as address to lookup the NOT result
    always @(*) begin
        out = not_lut[in];
    end
endmodule
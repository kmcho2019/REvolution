module TopModule (
    input  [7:0] in,
    output [31:0] out
);

    // LUT for sign extension
    reg [31:0] sign_extend_lut [0:255];
    
    // Initialize LUT with pre-computed sign-extended values
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            sign_extend_lut[i] = {{24{i[7]}}, i[7:0]};
        end
    end

    // Output the sign-extended value from LUT
    assign out = sign_extend_lut[in];

endmodule
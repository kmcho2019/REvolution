module TopModule (
    input [7:0] in,
    output [31:0] out
);

    // Initialize a lookup table (LUT) to store the replicated sign bits
    reg [31:0] lut [255:0];

    // Initialize the LUT with the replicated sign bits for each possible input value
    initial begin
        for (int i = 0; i < 256; i++) begin
            if (i[7]) begin
                lut[i] = {24{1'b1}, i[7:0]};
            end else begin
                lut[i] = {24{1'b0}, i[7:0]};
            end
        end
    end

    // Use the LUT to look up the replicated sign bits for the input number
    assign out = lut[in];

endmodule
module TopModule (
    input  wire [15:0] scancode,
    output reg         left,
    output reg         down,
    output reg         right,
    output reg         up
);

    // Define the lookup table (LUT) as an array of 4-bit values
    wire [3:0] lut [0:65535];

    // Initialize the LUT with the mapping of scancodes to arrow key outputs
    initial begin
        for (int i = 0; i < 65536; i++) begin
            case (i)
                16'he06b: lut[i] = 4'b0001; // left arrow
                16'he072: lut[i] = 4'b0010; // down arrow
                16'he074: lut[i] = 4'b0100; // right arrow
                16'he075: lut[i] = 4'b1000; // up arrow
                default: lut[i] = 4'b0000; // none
            endcase
        end
    end

    // Use the LUT to generate the output
    always @(*) begin
        {up, right, down, left} = lut[scancode];
    end

endmodule
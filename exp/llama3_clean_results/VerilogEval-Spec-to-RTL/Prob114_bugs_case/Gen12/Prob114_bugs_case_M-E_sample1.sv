module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    reg [3:0] scancode_out [256]; // Assuming 8-bit scancodes, we need 2^8 entries
    integer i;

    // Initialize the array with scancodes and their outputs
    initial begin
        for (i = 0; i < 256; i++) begin
            scancode_out[i] = 4'h0; // Default output
        end
        scancode_out[8'h45] = 4'h0;
        scancode_out[8'h16] = 4'h1;
        scancode_out[8'h1e] = 4'h2;
        scancode_out[8'h26] = 4'h3;
        scancode_out[8'h25] = 4'h4;
        scancode_out[8'h2e] = 4'h5;
        scancode_out[8'h36] = 4'h6;
        scancode_out[8'h3d] = 4'h7;
        scancode_out[8'h3e] = 4'h8;
        scancode_out[8'h46] = 4'h9;
    end

    always @(*) begin
        out = scancode_out[code];
        valid = (code == 8'h45 || code == 8'h16 || code == 8'h1e || code == 8'h26 || code == 8'h25 || code == 8'h2e || code == 8'h36 || code == 8'h3d || code == 8'h3e || code == 8'h46) ? 1'b1 : 1'b0;
    end

endmodule
module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] rom [256]; // Initialize a ROM with 256 entries (8-bit address space)

    initial begin
        // Initialize the ROM with output values for each scancode
        rom[8'h45] = 4'd0;
        rom[8'h16] = 4'd1;
        rom[8'h1e] = 4'd2;
        rom[8'h26] = 4'd3;
        rom[8'h25] = 4'd4;
        rom[8'h2e] = 4'd5;
        rom[8'h36] = 4'd6;
        rom[8'h3d] = 4'd7;
        rom[8'h3e] = 4'd8;
        rom[8'h46] = 4'd9;
    end

    always @(*) begin
        out = 4'd0; // Default value for out
        valid = 1'b0; // Default value for valid

        if (code == 8'h45 || code == 8'h16 || code == 8'h1e || code == 8'h26 ||
            code == 8'h25 || code == 8'h2e || code == 8'h36 || code == 8'h3d ||
            code == 8'h3e || code == 8'h46) begin
            out = rom[code]; // Use the input scancode as an address to access the ROM
            valid = 1'b1;
        end
    end

endmodule
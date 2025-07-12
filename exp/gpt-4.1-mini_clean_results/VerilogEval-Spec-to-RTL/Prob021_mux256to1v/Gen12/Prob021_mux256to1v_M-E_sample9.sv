module TopModule (
    input  wire [1023:0] in,
    input  wire [7:0]    sel,
    output wire [3:0]    out
);

    // Define a 256-entry array, each 4 bits wide
    wire [3:0] rom [0:255];

    // Unpack the 1024-bit input vector into the 256-entry 4-bit ROM array
    genvar idx;
    generate
        for (idx = 0; idx < 256; idx = idx + 1) begin : unpack_loop
            assign rom[idx] = in[idx*4 +: 4];
        end
    endgenerate

    // Output is selected directly by sel as an address into the rom
    assign out = rom[sel];

endmodule
module TopModule (
    input [7:0] in,
    output parity
);
    // 256-bit ROM storing all possible even parity results
    reg [255:0] parity_rom = 256'b0;
    
    // Initialize the ROM with precomputed parity values
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            parity_rom[i] = ^(i[7:0]);  // Compute even parity for each possible byte
        end
    end

    // Output the precomputed parity for the current input
    assign parity = parity_rom[in];
endmodule
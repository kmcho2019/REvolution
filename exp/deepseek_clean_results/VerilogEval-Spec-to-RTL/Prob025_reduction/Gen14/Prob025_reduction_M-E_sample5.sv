module TopModule (
    input [7:0] in,
    output parity
);
    // 256-entry parity LUT (ROM)
    reg [0:255] parity_rom;

    // Initialize ROM with precomputed parity values
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            parity_rom[i] = ^i[7:0];  // Precompute even parity
        end
    end

    // Output the parity bit for the current input
    assign parity = parity_rom[in];
endmodule
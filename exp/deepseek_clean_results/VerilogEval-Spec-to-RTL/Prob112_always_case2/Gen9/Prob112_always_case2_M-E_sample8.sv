module TopModule (
    input [3:0] in,
    output reg [1:0] pos
);

always_comb begin
    // Check upper half first (bits 3 and 2)
    if (in[3] | in[2]) begin
        // Upper half has priority
        if (in[3]) begin
            pos = 2'b11;  // Bit 3 is highest priority
        end else begin
            pos = 2'b10;  // Bit 2 is highest priority
        end
    end
    // Then check lower half (bits 1 and 0)
    else if (in[1] | in[0]) begin
        // Lower half has priority
        if (in[1]) begin
            pos = 2'b01;  // Bit 1 is highest priority
        end else begin
            pos = 2'b00;  // Bit 0 is highest priority
        end
    end
    else begin
        // All bits are zero
        pos = 2'b00;
    end
end

endmodule
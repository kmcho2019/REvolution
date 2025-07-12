module TopModule(
    input  [1023:0] in,
    input  [7:0]    sel,
    output reg [3:0] out
);

    always @(*) begin
        // Calculate base index for slice start
        integer base_idx;
        base_idx = sel * 4;

        // Extract the 4-bit slice from 'in' based on sel
        // Add default fallback to zeros if sel is out of range (not strictly needed as sel is 8-bit but safe)
        if (base_idx <= 1020) 
            out = in[base_idx +: 4];
        else
            out = 4'b0000;
    end

endmodule
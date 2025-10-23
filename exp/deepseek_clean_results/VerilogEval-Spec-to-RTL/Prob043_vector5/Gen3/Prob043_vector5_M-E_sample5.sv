module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Input combination forms the address
    wire [4:0] addr = {a, b, c, d, e};
    
    // 32x25 ROM storing all possible comparison results
    reg [24:0] rom [0:31];
    
    // Initialize ROM with precomputed values
    integer i, j, k;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                for (k = 0; k < 5; k = k + 1) begin
                    rom[i][(4-j)*5 + (4-k)] = ~((i[4-j] ^ i[4-k]));
                end
            end
        end
    end
    
    // Output the precomputed result
    assign out = rom[addr];

endmodule
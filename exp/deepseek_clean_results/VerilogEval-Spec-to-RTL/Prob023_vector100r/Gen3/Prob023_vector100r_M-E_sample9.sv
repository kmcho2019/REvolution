module TopModule (
    input  [99:0] in,
    output [99:0] out
);

genvar i;
generate
    // Start with temp as input
    wire [99:0] temp [6:0];
    assign temp[0] = in;
    
    // Hierarchical bit reversal
    for (i = 0; i < 6; i = i + 1) begin : reverse
        localparam SWAP_DIST = 50 >> i;
        integer j;
        always @(*) begin
            for (j = 0; j < 100; j = j + 1) begin
                if (j < SWAP_DIST) begin
                    temp[i+1][j] = temp[i][j + SWAP_DIST];
                    temp[i+1][j + SWAP_DIST] = temp[i][j];
                end
                else if (j < 2*SWAP_DIST) begin
                    // Already swapped
                end
                else begin
                    temp[i+1][j] = temp[i][j];
                end
            end
        end
    end
endgenerate

assign out = temp[6];

endmodule
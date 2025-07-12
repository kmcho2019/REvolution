module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    // First level: 16 16-to-1 muxes using direct indexing
    wire [3:0] first_level [0:15];
    
    integer i;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            first_level[i] = in[(i*64) + (sel[3:0]*4) +: 4];
        end
    end

    // Second level: direct 16-to-1 selection
    assign out = first_level[sel[7:4]];

endmodule
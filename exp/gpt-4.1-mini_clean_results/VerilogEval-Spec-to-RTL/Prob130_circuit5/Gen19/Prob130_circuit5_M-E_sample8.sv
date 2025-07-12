module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define selector codes for each c value (0-15)
    // 2'b00 = b, 2'b01 = e, 2'b10 = a, 2'b11 = d, 4'bxxxx for constant output 0xF
    // Since c is 4-bit, LUT has 16 entries.
    // For c >=4, selector is 4'hF meaning constant output.
    localparam [1:0] SEL_B = 2'b00;
    localparam [1:0] SEL_E = 2'b01;
    localparam [1:0] SEL_A = 2'b10;
    localparam [1:0] SEL_D = 2'b11;
    localparam [3:0] CONST_F = 4'hF;

    // LUT: map c to selector (2-bit), using 2 bits for selectors, 4 bits for constants handled separately
    reg [1:0] lut [0:15];
    integer i;
    initial begin
        // Initialize all entries to SEL_B by default (won't be used for c≥4)
        for (i=0; i<16; i=i+1)
            lut[i] = SEL_B;

        lut[0] = SEL_B; // c=0 → b
        lut[1] = SEL_E; // c=1 → e
        lut[2] = SEL_A; // c=2 → a
        lut[3] = SEL_D; // c=3 → d
        // c=4..15 are invalid selectors for mux, so we won't use LUT for these
    end

    always @(*) begin
        if (c >= 4'd4)
            q = CONST_F;  // For c >=4, output 0xF
        else begin
            case (lut[c])
                SEL_B: q = b;
                SEL_E: q = e;
                SEL_A: q = a;
                SEL_D: q = d;
                default: q = 4'h0; // Should never occur
            endcase
        end
    end

endmodule
module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Define a ROM array for the 5 possible outputs
    wire [3:0] rom [0:4];
    assign rom[0] = b;
    assign rom[1] = e;
    assign rom[2] = a;
    assign rom[3] = d;
    assign rom[4] = 4'hF;

    // Cap the index to maximum 4 to avoid out-of-range indexing
    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    // Combinational multiplexer using case statement on idx
    always @(*) begin
        case (idx)
            3'd0: q = rom[0];
            3'd1: q = rom[1];
            3'd2: q = rom[2];
            3'd3: q = rom[3];
            default: q = rom[4]; // For idx >= 4
        endcase
    end

endmodule
module TopModule (
    input  [2:0] a,
    output reg [15:0] q
);

    // Define a localparam array holding all output values indexed by 'a'
    localparam [15:0] lookup_table [0:7] = {
        16'h2f19, // a=7 (last)
        16'hc526, // a=6
        16'h64ce, // a=5
        16'h2066, // a=4
        16'h5a0e, // a=3
        16'h27d4, // a=2
        16'haee0, // a=1
        16'h1232  // a=0 (first)
    };

    // Combinational always block with a case statement to decode 'a'
    always @(*) begin
        case (a)
            3'd0: q = lookup_table[0];
            3'd1: q = lookup_table[1];
            3'd2: q = lookup_table[2];
            3'd3: q = lookup_table[3];
            3'd4: q = lookup_table[4];
            3'd5: q = lookup_table[5];
            3'd6: q = lookup_table[6];
            3'd7: q = lookup_table[7];
            default: q = 16'h0000;
        endcase
    end

endmodule
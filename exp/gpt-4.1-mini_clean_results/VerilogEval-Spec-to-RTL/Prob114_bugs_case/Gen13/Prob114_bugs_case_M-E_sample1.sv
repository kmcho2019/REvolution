module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    // Number of recognized codes
    localparam NUM_CODES = 10;

    // Array of recognized scancodes
    reg [7:0] codes [0:NUM_CODES-1];
    // Array of corresponding digits
    reg [3:0] digits [0:NUM_CODES-1];

    integer i;
    reg found;

    // Initialize code-digit arrays (synthesis tools usually accept this)
    initial begin
        codes[0] = 8'h45; digits[0] = 4'd0;
        codes[1] = 8'h16; digits[1] = 4'd1;
        codes[2] = 8'h1e; digits[2] = 4'd2;
        codes[3] = 8'h26; digits[3] = 4'd3;
        codes[4] = 8'h25; digits[4] = 4'd4;
        codes[5] = 8'h2e; digits[5] = 4'd5;
        codes[6] = 8'h36; digits[6] = 4'd6;
        codes[7] = 8'h3d; digits[7] = 4'd7;
        codes[8] = 8'h3e; digits[8] = 4'd8;
        codes[9] = 8'h46; digits[9] = 4'd9;
    end

    always @(*) begin
        found = 1'b0;
        out = 4'd0;
        valid = 1'b0;

        for (i = 0; i < NUM_CODES; i = i + 1) begin
            if (code == codes[i]) begin
                out = digits[i];
                valid = 1'b1;
                found = 1'b1;
            end
        end
    end

endmodule
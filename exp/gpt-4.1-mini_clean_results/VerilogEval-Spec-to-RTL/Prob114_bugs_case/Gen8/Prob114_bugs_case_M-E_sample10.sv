module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    // Number of recognized keys
    localparam N_KEYS = 10;

    // Known key codes in an array
    wire [7:0] key_codes [0:N_KEYS-1];
    assign key_codes[0] = 8'h45; // 0
    assign key_codes[1] = 8'h16; // 1
    assign key_codes[2] = 8'h1E; // 2
    assign key_codes[3] = 8'h26; // 3
    assign key_codes[4] = 8'h25; // 4
    assign key_codes[5] = 8'h2E; // 5
    assign key_codes[6] = 8'h36; // 6
    assign key_codes[7] = 8'h3D; // 7
    assign key_codes[8] = 8'h3E; // 8
    assign key_codes[9] = 8'h46; // 9

    integer i;
    always @* begin
        out = 4'd0;
        valid = 1'b0;
        for (i = 0; i < N_KEYS; i = i + 1) begin
            if (code == key_codes[i]) begin
                out = i[3:0];
                valid = 1'b1;
            end
        end
    end

endmodule
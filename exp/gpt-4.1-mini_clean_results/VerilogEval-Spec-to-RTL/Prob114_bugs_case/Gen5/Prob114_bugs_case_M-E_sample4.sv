module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output valid
);

    // Define the 10 known scancodes and their corresponding digits
    localparam integer NUM_KEYS = 10;
    wire [7:0] scancodes [0:NUM_KEYS-1];
    wire [3:0] digits    [0:NUM_KEYS-1];

    assign scancodes[0] = 8'h45; // 0
    assign digits[0]    = 4'd0;
    assign scancodes[1] = 8'h16; // 1
    assign digits[1]    = 4'd1;
    assign scancodes[2] = 8'h1E; // 2
    assign digits[2]    = 4'd2;
    assign scancodes[3] = 8'h26; // 3
    assign digits[3]    = 4'd3;
    assign scancodes[4] = 8'h25; // 4
    assign digits[4]    = 4'd4;
    assign scancodes[5] = 8'h2E; // 5
    assign digits[5]    = 4'd5;
    assign scancodes[6] = 8'h36; // 6
    assign digits[6]    = 4'd6;
    assign scancodes[7] = 8'h3D; // 7
    assign digits[7]    = 4'd7;
    assign scancodes[8] = 8'h3E; // 8
    assign digits[8]    = 4'd8;
    assign scancodes[9] = 8'h46; // 9
    assign digits[9]    = 4'd9;

    // Generate match flags for each known scancode
    wire [NUM_KEYS-1:0] matches;
    genvar i;
    generate
        for (i = 0; i < NUM_KEYS; i = i + 1) begin : match_gen
            assign matches[i] = (code == scancodes[i]);
        end
    endgenerate

    // Find which key matched (if any)
    integer j;
    always @(*) begin
        out = 4'd0; // Default output 0
        for (j = 0; j < NUM_KEYS; j = j + 1) begin
            if (matches[j]) begin
                out = digits[j];
                // stop at first match (no overlaps expected)
                disable for;
            end
        end
    end

    // valid is asserted if any match is found
    assign valid = |matches;

endmodule
module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// Define all valid scancodes
localparam [7:0] SCANCODES [0:9] = '{
    8'h45,  // 0
    8'h16,  // 1
    8'h1e,  // 2
    8'h26,  // 3
    8'h25,  // 4
    8'h2e,  // 5
    8'h36,  // 6
    8'h3d,  // 7
    8'h3e,  // 8
    8'h46   // 9
};

// Parallel comparators for each scancode
wire [9:0] matches;
generate
    genvar i;
    for (i = 0; i < 10; i = i + 1) begin : scancode_comparators
        assign matches[i] = (code == SCANCODES[i]);
    end
endgenerate

// Valid signal is OR of all matches
assign valid = |matches;

// Priority encoder for output
assign out = 
    matches[0] ? 4'd0 :
    matches[1] ? 4'd1 :
    matches[2] ? 4'd2 :
    matches[3] ? 4'd3 :
    matches[4] ? 4'd4 :
    matches[5] ? 4'd5 :
    matches[6] ? 4'd6 :
    matches[7] ? 4'd7 :
    matches[8] ? 4'd8 :
    matches[9] ? 4'd9 :
    4'd0;

endmodule
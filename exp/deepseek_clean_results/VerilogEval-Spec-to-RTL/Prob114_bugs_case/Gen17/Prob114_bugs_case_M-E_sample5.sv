module TopModule (
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

// Define ROM of valid scancodes and their corresponding outputs
localparam NUM_KEYS = 10;
localparam [7:0] SCANCODES [0:NUM_KEYS-1] = '{
    8'h45, 8'h16, 8'h1e, 8'h26, 8'h25,
    8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
};

// Generate match signals for each valid scancode
wire [NUM_KEYS-1:0] matches;
genvar i;
generate
    for (i = 0; i < NUM_KEYS; i = i + 1) begin : gen_comparators
        assign matches[i] = (code == SCANCODES[i]);
    end
endgenerate

// Priority encoder to convert matches to output
always @(*) begin
    out = 0;
    valid = |matches;  // OR reduction of all matches
    
    if (valid) begin
        case (1'b1)
            matches[0]: out = 0;
            matches[1]: out = 1;
            matches[2]: out = 2;
            matches[3]: out = 3;
            matches[4]: out = 4;
            matches[5]: out = 5;
            matches[6]: out = 6;
            matches[7]: out = 7;
            matches[8]: out = 8;
            matches[9]: out = 9;
            default: out = 0;
        endcase
    end
end

endmodule
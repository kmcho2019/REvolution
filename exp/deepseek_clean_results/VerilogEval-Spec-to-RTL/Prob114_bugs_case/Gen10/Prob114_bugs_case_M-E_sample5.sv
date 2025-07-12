module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Define valid scancodes and their corresponding digits
localparam NUM_CODES = 10;
localparam [7:0] CODES [0:NUM_CODES-1] = '{
    8'h45, 8'h16, 8'h1e, 8'h26, 8'h25,
    8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
};
localparam [3:0] DIGITS [0:NUM_CODES-1] = '{
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9
};

// Generate match signals for each valid code
wire [NUM_CODES-1:0] matches;
genvar i;
generate
    for (i = 0; i < NUM_CODES; i = i + 1) begin : gen_match
        assign matches[i] = (code == CODES[i]);
    end
endgenerate

// Priority encoder to select the correct digit
always @(*) begin
    out = 0;
    valid = |matches;  // OR of all match signals
    
    for (int j = 0; j < NUM_CODES; j = j + 1) begin
        if (matches[j]) begin
            out = DIGITS[j];
        end
    end
end

endmodule
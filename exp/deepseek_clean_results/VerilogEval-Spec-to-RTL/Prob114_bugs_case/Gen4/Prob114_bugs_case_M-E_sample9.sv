module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// Define key code mappings
localparam NUM_KEYS = 10;
localparam [7:0] KEY_CODES [0:NUM_KEYS-1] = '{
    8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 
    8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
};
localparam [3:0] KEY_VALUES [0:NUM_KEYS-1] = '{
    4'd0, 4'd1, 4'd2, 4'd3, 4'd4,
    4'd5, 4'd6, 4'd7, 4'd8, 4'd9
};

// Generate match signals
wire [NUM_KEYS-1:0] matches;
genvar i;
generate
    for (i = 0; i < NUM_KEYS; i = i + 1) begin : match_gen
        assign matches[i] = (code == KEY_CODES[i]);
    end
endgenerate

// Priority encoder for output selection
always @(*) begin
    out = 0;
    valid = |matches;  // OR reduction of all match signals
    
    for (integer j = 0; j < NUM_KEYS; j = j + 1) begin
        if (matches[j]) begin
            out = KEY_VALUES[j];
        end
    end
end

endmodule
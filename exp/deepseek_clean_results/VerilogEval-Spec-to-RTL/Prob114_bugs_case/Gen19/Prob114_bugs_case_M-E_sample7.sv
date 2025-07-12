module TopModule (
    input [7:0] code,
    output reg [3:0] out = 0,
    output reg valid = 0
);

// LUT for scancodes and corresponding outputs
localparam NUM_CODES = 10;
localparam [7:0] SCANCODES [0:NUM_CODES-1] = '{
    8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 
    8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
};
localparam [3:0] OUTPUTS [0:NUM_CODES-1] = '{
    4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 
    4'd5, 4'd6, 4'd7, 4'd8, 4'd9
};

// Parallel comparison logic
wire [NUM_CODES-1:0] matches;
genvar i;
generate
    for (i = 0; i < NUM_CODES; i = i + 1) begin : gen_comp
        assign matches[i] = (code == SCANCODES[i]);
    end
endgenerate

// Output selection logic
always @(*) begin
    out = 0;
    valid = |matches;  // OR reduction of all matches
    
    // Priority encoder (though only one should match)
    for (int j = 0; j < NUM_CODES; j = j + 1) begin
        if (matches[j]) begin
            out = OUTPUTS[j];
        end
    end
end

endmodule
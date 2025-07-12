module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out_sop,
    output reg out_pos
);

reg [15:0] decoder_out;

always @(*)
begin
    // Initialize the decoder output
    decoder_out = 16'b0;

    // Generate the decoder output
    case ({a, b, c, d})
        4'b0010: decoder_out[2] = 1'b1; // 2
        4'b0111: decoder_out[7] = 1'b1; // 7
        4'b1111: decoder_out[15] = 1'b1; // 15
        default: decoder_out = 16'b0;
    endcase

    // Generate the out_sop output
    out_sop = decoder_out[2] | decoder_out[7] | decoder_out[15];

    // Generate the out_pos output
    out_pos = ((b || c || d) && (a || b || c || d)) || 
              ((b || !a || !c || !d) && (b || c || d));
end

endmodule
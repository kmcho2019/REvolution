module TopModule (
    input [7:0] code,
    output [3:0] out,
    output valid
);

// List of valid scancodes in order 0-9
wire [7:0] valid_codes [0:9] = '{8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 
                                 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46};
wire [9:0] match;

// Generate match signals for each valid code
genvar i;
generate
    for (i = 0; i < 10; i = i + 1) begin
        assign match[i] = (code == valid_codes[i]);
    end
endgenerate

// Output is the index of the matched code (0-9)
assign out = match[0] ? 4'd0 :
             match[1] ? 4'd1 :
             match[2] ? 4'd2 :
             match[3] ? 4'd3 :
             match[4] ? 4'd4 :
             match[5] ? 4'd5 :
             match[6] ? 4'd6 :
             match[7] ? 4'd7 :
             match[8] ? 4'd8 :
             match[9] ? 4'd9 : 4'd0;

// Valid is OR of all match signals
assign valid = |match;

endmodule
module TopModule (
    input  [255:0] in,
    input  [7:0] sel,
    output out
);

// Level 1: 16-to-1 multiplexers
wire [15:0] out_level1;

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        assign out_level1[i] = in[i * 16 + sel[3:0]];
    end
endgenerate

// Level 2: 16-to-1 multiplexer
wire out_level2;

assign out_level2 = out_level1[sel[7:4]];

// Final output
assign out = out_level2;

endmodule
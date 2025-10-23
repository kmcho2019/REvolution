// Define the LowerByteExtractor module
module LowerByteExtractor(
    input  [15:0] in,
    output [7:0] out
);
    assign out = in[7:0];
endmodule

// Define the UpperByteExtractor module
module UpperByteExtractor(
    input  [15:0] in,
    output [7:0] out
);
    assign out = in[15:8];
endmodule

// Define the TopModule, instantiating the byte extractors
module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);
    LowerByteExtractor lower_byte_extractor(
       .in(in),
       .out(out_lo)
    );
    
    UpperByteExtractor upper_byte_extractor(
       .in(in),
       .out(out_hi)
    );
endmodule
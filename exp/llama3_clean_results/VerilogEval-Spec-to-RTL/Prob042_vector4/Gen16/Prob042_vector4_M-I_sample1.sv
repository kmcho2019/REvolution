module SignExtend #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 32
) (
    input [INPUT_WIDTH-1:0] in,
    output [OUTPUT_WIDTH-1:0] out
);

    // Assign the replicated MSB concatenated with the input to the output
    assign out = { {(OUTPUT_WIDTH-INPUT_WIDTH){in[INPUT_WIDTH-1]}}, in };

    // Add synthesis attributes to optimize the design for better PPA
    (* keep *) out;
    (* full_case *) out;
    (* parallel_case *) out;

endmodule

module TopModule (
    input [7:0] in,
    output [31:0] out
);

    SignExtend #(.INPUT_WIDTH(8),.OUTPUT_WIDTH(32)) se (.in(in),.out(out));

    // Add synthesis attributes to optimize the design for better PPA
    (* keep *) se;
    (* full_case *) se;
    (* parallel_case *) se;

endmodule
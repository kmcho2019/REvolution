module Mux2to1 (
    input  wire in0,
    input  wire in1,
    input  wire sel,
    output wire out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output wire         out
);
    // Recursive function to build the mux tree
    // It returns the output of the mux selecting one bit from "width" inputs starting at in[offset]
    // sel_index indicates which bit of sel to use for this level of muxing
    function automatic wire build_mux_tree;
        input integer offset;        // starting index in in vector
        input integer width;         // number of inputs at this level
        input integer sel_index;     // which bit of sel to use for this mux level
        integer half;
        wire lower0, lower1;
    begin
        if (width == 1) begin
            build_mux_tree = in[offset];
        end else begin
            half = width / 2;
            lower0 = build_mux_tree(offset,     half, sel_index - 1);
            lower1 = build_mux_tree(offset+half, half, sel_index - 1);
            build_mux_tree = (sel[sel_index]) ? lower1 : lower0;
        end
    end
    endfunction

    // The MSB of sel is used at the root level (sel[7]), LSB at leaf level (sel[0])
    assign out = build_mux_tree(0, 256, 7);

endmodule
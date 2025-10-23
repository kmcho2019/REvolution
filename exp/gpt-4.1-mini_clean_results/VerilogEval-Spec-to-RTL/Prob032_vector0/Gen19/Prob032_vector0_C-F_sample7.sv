module BitSplitter #(
    parameter WIDTH = 3
) (
    input  [WIDTH-1:0] in_vec,
    output             o0,
    output             o1,
    output             o2
);
    // Generate continuous assignments directly to each output port
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_out_assign
            if (i == 0) assign o0 = in_vec[i];
            else if (i == 1) assign o1 = in_vec[i];
            else if (i == 2) assign o2 = in_vec[i];
        end
    endgenerate
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly connect outv to vec for minimal logic and routing overhead
    assign outv = vec;

    // Instantiate BitSplitter parameterized for 3 bits with generate-based assignments
    BitSplitter #(.WIDTH(3)) splitter (
        .in_vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2)
    );

endmodule
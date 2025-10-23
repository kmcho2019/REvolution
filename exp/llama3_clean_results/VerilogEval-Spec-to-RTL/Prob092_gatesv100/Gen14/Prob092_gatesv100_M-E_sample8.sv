module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Define internal wires for pipeline stages
    wire [99:0] stage1_out_both;
    wire [99:0] stage1_out_any;
    wire [99:0] stage1_out_different;

    // Stage 1: Perform out_both calculation
    module_out_both stage1_out_both_module(
        .in(in),
        .out(stage1_out_both)
    );

    // Stage 2: Perform out_any calculation
    module_out_any stage1_out_any_module(
        .in(in),
        .out(stage1_out_any)
    );

    // Stage 3: Perform out_different calculation with wrap-around
    module_out_different stage1_out_different_module(
        .in(in),
        .out(stage1_out_different)
    );

    // Assign output from final stages to output ports
    assign out_both = stage1_out_both;
    assign out_any = stage1_out_any;
    assign out_different = stage1_out_different;

endmodule

// Module for out_both calculation
module module_out_both(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 99) begin
                assign out[i] = 1'b0; // out_both[99] is always 0
            end else begin
                assign out[i] = in[i] & in[i+1];
            end
        end
    endgenerate
endmodule

// Module for out_any calculation
module module_out_any(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            if (i == 0) begin
                assign out[i] = 1'b0; // out_any[0] is always 0
            end else begin
                assign out[i] = in[i] | in[i-1];
            end
        end
    endgenerate
endmodule

// Module for out_different calculation with wrap-around
module module_out_different(
    input [99:0] in,
    output [99:0] out
);
    genvar i;
    generate
        for (i = 0; i < 100; i = i + 1) begin
            assign out[i] = in[i] ^ ((i == 99)? in[0] : in[i+1]);
        end
    endgenerate
endmodule
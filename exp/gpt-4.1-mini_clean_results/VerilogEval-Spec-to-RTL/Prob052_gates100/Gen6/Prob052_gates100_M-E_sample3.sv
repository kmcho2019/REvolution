module TopModule (
    input  [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameters for group size and number of inputs
    localparam GROUP = 4;

    // Calculate number of stages needed to reduce 100 inputs to 1 output
    // by grouping inputs in groups of GROUP.
    // stage_sizes: number of elements at each stage.
    // Since 100 is not a power of 4, last group may have fewer bits.
    
    // Stage 0 size = 100 (input)
    // Stage 1 size = ceil(100/4) = 25
    // Stage 2 size = ceil(25/4) = 7
    // Stage 3 size = ceil(7/4) = 2
    // Stage 4 size = ceil(2/4) = 1 --> final output
    
    // We'll implement this with a parameterized reduction tree.

    // First, define small 4-input gates with parameterized input width
    module small_and #(parameter WIDTH = GROUP) (input [WIDTH-1:0] in, output out);
        assign out = &in;
    endmodule

    module small_or #(parameter WIDTH = GROUP) (input [WIDTH-1:0] in, output out);
        assign out = |in;
    endmodule

    module small_xor #(parameter WIDTH = GROUP) (input [WIDTH-1:0] in, output out);
        assign out = ^in;
    endmodule

    // Define a generic reduction tree module for AND, OR, XOR
    // The reduction divides input into groups of GROUP and reduces each group,
    // then repeats until one output remains.
    // Use generate blocks and parameterization for reusability.

    // Tree reduction module for AND
    module reduce_and #(parameter WIDTH = 100) (input [WIDTH-1:0] in, output out);
        // If WIDTH <= GROUP, reduce directly:
        if (WIDTH <= GROUP) begin
            small_and #(WIDTH) and_gate(.in(in), .out(out));
        end else begin
            // Split input into groups of GROUP size (last group may be smaller)
            localparam GROUPS = (WIDTH + GROUP - 1) / GROUP;
            wire [GROUPS-1:0] intermediate;
            genvar i;
            generate
                for (i = 0; i < GROUPS; i = i + 1) begin : gen_and_groups
                    // Calculate group size for this group:
                    localparam int group_size = ((i+1)*GROUP <= WIDTH) ? GROUP : (WIDTH - i*GROUP);
                    small_and #(group_size) and_inst(.in(in[i*GROUP +: group_size]), .out(intermediate[i]));
                end
            endgenerate
            // Recursively reduce intermediate outputs
            reduce_and #(GROUPS) next_stage(.in(intermediate), .out(out));
        end
    endmodule

    // Tree reduction module for OR
    module reduce_or #(parameter WIDTH = 100) (input [WIDTH-1:0] in, output out);
        if (WIDTH <= GROUP) begin
            small_or #(WIDTH) or_gate(.in(in), .out(out));
        end else begin
            localparam GROUPS = (WIDTH + GROUP - 1) / GROUP;
            wire [GROUPS-1:0] intermediate;
            genvar i;
            generate
                for (i = 0; i < GROUPS; i = i + 1) begin : gen_or_groups
                    localparam int group_size = ((i+1)*GROUP <= WIDTH) ? GROUP : (WIDTH - i*GROUP);
                    small_or #(group_size) or_inst(.in(in[i*GROUP +: group_size]), .out(intermediate[i]));
                end
            endgenerate
            reduce_or #(GROUPS) next_stage(.in(intermediate), .out(out));
        end
    endmodule

    // Tree reduction module for XOR
    module reduce_xor #(parameter WIDTH = 100) (input [WIDTH-1:0] in, output out);
        if (WIDTH <= GROUP) begin
            small_xor #(WIDTH) xor_gate(.in(in), .out(out));
        end else begin
            localparam GROUPS = (WIDTH + GROUP - 1) / GROUP;
            wire [GROUPS-1:0] intermediate;
            genvar i;
            generate
                for (i = 0; i < GROUPS; i = i + 1) begin : gen_xor_groups
                    localparam int group_size = ((i+1)*GROUP <= WIDTH) ? GROUP : (WIDTH - i*GROUP);
                    small_xor #(group_size) xor_inst(.in(in[i*GROUP +: group_size]), .out(intermediate[i]));
                end
            endgenerate
            reduce_xor #(GROUPS) next_stage(.in(intermediate), .out(out));
        end
    endmodule

    // Instantiate reductions for 100 inputs
    reduce_and #(100) and_reduce(.in(in), .out(out_and));
    reduce_or  #(100) or_reduce(.in(in),  .out(out_or));
    reduce_xor #(100) xor_reduce(.in(in), .out(out_xor));

endmodule
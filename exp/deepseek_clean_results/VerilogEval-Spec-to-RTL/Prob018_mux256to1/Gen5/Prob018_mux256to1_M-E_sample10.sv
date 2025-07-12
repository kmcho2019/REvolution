module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive binary tree mux implementation
    wire [255:0] tree_inputs = in;
    wire [7:0] select = sel;
    
    // Instantiate the root of the binary tree
    mux_tree_node #(
        .INPUT_COUNT(256),
        .SEL_WIDTH(8)
    root_node (
        .inputs(tree_inputs),
        .sel(select),
        .out(out)
    );

endmodule

// Parameterized binary tree node module
module mux_tree_node #(
    parameter INPUT_COUNT = 256,
    parameter SEL_WIDTH = 8
) (
    input  [INPUT_COUNT-1:0] inputs,
    input  [SEL_WIDTH-1:0]  sel,
    output                  out
);
    
    generate
        if (INPUT_COUNT == 2) begin : leaf
            // Base case: 2-to-1 mux
            assign out = sel[0] ? inputs[1] : inputs[0];
        end
        else begin : branch
            // Recursive case: split inputs and instantiate child nodes
            localparam HALF_SIZE = INPUT_COUNT/2;
            wire left_out, right_out;
            
            mux_tree_node #(
                .INPUT_COUNT(HALF_SIZE),
                .SEL_WIDTH(SEL_WIDTH-1)
            left_child (
                .inputs(inputs[HALF_SIZE-1:0]),
                .sel(sel[SEL_WIDTH-2:0]),
                .out(left_out)
            );
            
            mux_tree_node #(
                .INPUT_COUNT(HALF_SIZE),
                .SEL_WIDTH(SEL_WIDTH-1)
            right_child (
                .inputs(inputs[2*HALF_SIZE-1:HALF_SIZE]),
                .sel(sel[SEL_WIDTH-2:0]),
                .out(right_out)
            );
            
            // Select between children using MSB of selector
            assign out = sel[SEL_WIDTH-1] ? right_out : left_out;
        end
    endgenerate

endmodule
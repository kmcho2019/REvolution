module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output        out
);

    // Recursive binary tree mux module
    module binary_tree_mux #(
        parameter WIDTH = 256,
        parameter SEL_WIDTH = 8
    ) (
        input  [WIDTH-1:0] data,
        input  [SEL_WIDTH-1:0] select,
        output bit out
    );
        if (WIDTH == 1) begin
            assign out = data[0];
        end else begin
            localparam HALF_WIDTH = WIDTH / 2;
            wire upper_bit;
            wire lower_bit;
            
            binary_tree_mux #(
                .WIDTH(HALF_WIDTH),
                .SEL_WIDTH(SEL_WIDTH-1)
            ) upper_mux (
                .data(data[WIDTH-1:HALF_WIDTH]),
                .select(select[SEL_WIDTH-2:0]),
                .out(upper_bit)
            );
            
            binary_tree_mux #(
                .WIDTH(HALF_WIDTH),
                .SEL_WIDTH(SEL_WIDTH-1)
            ) lower_mux (
                .data(data[HALF_WIDTH-1:0]),
                .select(select[SEL_WIDTH-2:0]),
                .out(lower_bit)
            );
            
            assign out = select[SEL_WIDTH-1] ? upper_bit : lower_bit;
        end
    endmodule

    // Instantiate the root of the binary tree
    binary_tree_mux #(
        .WIDTH(256),
        .SEL_WIDTH(8)
    ) mux_tree (
        .data(in),
        .select(sel),
        .out(out)
    );

endmodule
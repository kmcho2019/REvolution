module buf_wrap #(parameter NAME = "buf") (input wire in, output wire out);
    assign out = in;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Direct assignments for one-to-one mappings to save area and power
    assign w = a;
    assign z = c;

    // Instantiate buffers for duplicated outputs from the same input for clarity and modularity
    buf_wrap #(.NAME("buf_x")) buf_x_inst (.in(b), .out(x));
    buf_wrap #(.NAME("buf_y")) buf_y_inst (.in(b), .out(y));

endmodule
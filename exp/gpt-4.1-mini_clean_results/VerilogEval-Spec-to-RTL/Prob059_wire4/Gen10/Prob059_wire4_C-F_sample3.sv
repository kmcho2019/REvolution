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

    // Direct assignments for unique outputs to minimize area and power
    assign w = a;
    assign z = c;

    // Single buffer instance drives one output; the other output shares this buffered signal
    wire b_buf;
    buf_wrap #(.NAME("buf_b")) buf_b_inst (.in(b), .out(b_buf));

    // Duplicate the buffered signal to outputs x and y
    assign x = b_buf;
    assign y = b_buf;

endmodule
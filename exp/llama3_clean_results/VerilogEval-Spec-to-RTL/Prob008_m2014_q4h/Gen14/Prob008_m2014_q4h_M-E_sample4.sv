module TopModule #(
    parameter WIDTH = 1
)(
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
    always_comb begin
        out = in;
    end
endmodule

// Instantiate the TopModule with the desired width
module TopModule_Instance(
    input  logic in,
    output logic out
);
    TopModule #(.WIDTH(1)) top_module(
        .in(in),
        .out(out)
    );
endmodule
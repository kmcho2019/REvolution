module TopModule #(
    parameter OUTPUT_WIDTH = 1
)(
    output [OUTPUT_WIDTH-1:0] out
);
    assign out = {OUTPUT_WIDTH{1'b0}};
endmodule

// For the specific case of a 1-bit output, instantiate the module as follows:
module TopModule_Instance(
    output out
);
    TopModule #(.OUTPUT_WIDTH(1)) top_module_inst(
       .out(out)
    );
endmodule
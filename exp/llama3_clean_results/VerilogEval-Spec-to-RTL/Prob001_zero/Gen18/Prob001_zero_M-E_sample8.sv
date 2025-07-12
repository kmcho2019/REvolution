// TopModule is designed to output a constant LOW signal, utilizing a parameter for flexibility.
// This approach allows for easy adaptation to different output widths if required in the future.
module TopModule #
(
    parameter WIDTH = 1  // Default width is 1 bit
)
(
    output [WIDTH-1:0] zero
);
    // Assign a constant LOW value to all bits of the output.
    assign zero = {WIDTH{1'b0}};
endmodule

// Instantiate the TopModule with the default width of 1 bit.
module TopModule_Inst;
    wire zero;
    TopModule #(.WIDTH(1)) top_module (
        .zero(zero)
    );
endmodule
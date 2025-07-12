// TopModule is designed to output a constant LOW signal directly.
module TopModule (
    output zero = 1'b0 // Directly assign a constant LOW value to the output.
);

endmodule

// Instantiate the TopModule.
module TopModule_Inst;
    wire zero;
    TopModule top_module (
        .zero(zero)
    );
endmodule
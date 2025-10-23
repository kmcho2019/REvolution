module TopModule (
    input  in,   // Input signal
    output out   // Output signal
);
    // Implement wire functionality using buffer concept
    bufif1 buffer_inst (
        .out(out),
        .in(in),
        .enable(1'b1)  // Permanently enabled
    );
endmodule
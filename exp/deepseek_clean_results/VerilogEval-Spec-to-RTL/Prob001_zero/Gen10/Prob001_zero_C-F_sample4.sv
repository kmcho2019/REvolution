module TopModule (
    output zero  // Constant LOW output (permanently tied to ground)
);
    assign zero = 1'b0;  // Direct ground connection - optimal implementation
endmodule
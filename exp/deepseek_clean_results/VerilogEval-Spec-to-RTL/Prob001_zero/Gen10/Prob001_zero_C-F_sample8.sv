module TopModule (
    output zero  // Constant LOW output (hardwired to ground)
);
    assign zero = 1'b0;  // Most efficient and optimal implementation
endmodule
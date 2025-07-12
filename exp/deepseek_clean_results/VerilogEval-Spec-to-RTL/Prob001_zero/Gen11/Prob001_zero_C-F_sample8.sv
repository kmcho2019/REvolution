module TopModule (
    output zero  // Constant LOW output
);
    assign zero = 1'b0;  // Optimal hardwired ground connection
endmodule
module TopModule (
    output out
);
    assign out = 1'b0 & 1'b1;  // Boolean expression that always evaluates to 0
endmodule
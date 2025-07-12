module TopModule (
    input x,
    input y,
    output z
);
    // MUX implementation where:
    // When x=0: select 0
    // When x=1: select ~y
    assign z = x ? ~y : 1'b0;
endmodule
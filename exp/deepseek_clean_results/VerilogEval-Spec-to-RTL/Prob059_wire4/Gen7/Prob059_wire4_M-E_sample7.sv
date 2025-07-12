module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Implement each output as a 2:1 mux with hardwired select
    assign w = (1'b0) ? b : a;  // Always selects a
    assign x = (1'b0) ? c : b;   // Always selects b
    assign y = (1'b1) ? b : a;   // Always selects b
    assign z = (1'b0) ? b : c;   // Always selects c
endmodule
module TopModule (
    input a,
    input b,
    output out
);
    assign out = ~(a | b);  // Alternative: assign out = a ~| b;
endmodule
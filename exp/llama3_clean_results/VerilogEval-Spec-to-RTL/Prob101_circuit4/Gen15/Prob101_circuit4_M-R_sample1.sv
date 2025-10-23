module TopModule(
    input  logic a,
    input  logic b,
    input  logic c,
    input  logic d,
    output logic q
);

always @(*) begin
    // The output q is 1 whenever b or c is 1, regardless of the values of a and d
    q = b || c;
end

endmodule
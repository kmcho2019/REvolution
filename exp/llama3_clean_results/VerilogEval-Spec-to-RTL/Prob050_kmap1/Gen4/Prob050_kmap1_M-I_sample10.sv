module TopModule(
    input a,
    input b,
    input c,
    output reg out
);

always @(*) begin
    // Directly implementing the OR logic as per the Karnaugh map
    out = a | b | c;
end

endmodule
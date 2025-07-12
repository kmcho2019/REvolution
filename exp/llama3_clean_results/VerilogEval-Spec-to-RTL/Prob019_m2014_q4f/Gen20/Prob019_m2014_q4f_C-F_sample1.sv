module TopModule(
    input  in1,
    input  in2,
    output reg out
);

always @(*) begin
    // Direct gate-level implementation with explicit inversion for clarity and efficiency
    out = in1 && !in2;
end

endmodule